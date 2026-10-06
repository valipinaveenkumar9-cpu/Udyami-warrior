import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:battery_plus/battery_plus.dart';
import 'api_service.dart';
import '../utils/session_manager.dart';

class BackgroundLocationService {
  static const String routeIdKey = "bg_route_id";
  static const String cpIdKey = "bg_cp_id";

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'location_tracking_channel',
      'Location Tracking',
      description: 'This channel is used for background location tracking.',
      importance: Importance.low,
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: false,
        isForegroundMode: true,
        notificationChannelId: 'location_tracking_channel',
        initialNotificationTitle: 'Tracking Location',
        initialNotificationContent: 'Initializing',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: false,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  Future<void> startTracking(String routeId, String cpId, List<dynamic> coordinates) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(routeIdKey, routeId);
    await prefs.setString(cpIdKey, cpId);
    await prefs.setString('bg_traversed_coords', '[]');
    
    // Check permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Request notification permission for Android 13+
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    final service = FlutterBackgroundService();
    await service.startService();
  }

  Future<void> stopTracking() async {
    final service = FlutterBackgroundService();
    service.invoke('stopService');
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(routeIdKey);
    await prefs.remove(cpIdKey);
    await prefs.remove('bg_traversed_coords');
  }
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  print("DEV DEBUG - bg_location - onStart initialized");
  DartPluginRegistrant.ensureInitialized();
  await SessionManager.init();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  Position? latestPosition;
  
  // Listen to live location updates from the OS instead of blocking polls
  try {
    final positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Get continuous high-precision updates without distance threshold
      )
    ).listen((Position position) {
      latestPosition = position;
    });
  } catch (e) {
    print("DEV DEBUG - bg_location - Failed to start position stream (possibly permission denied): $e");
  }

  // Start the timer to poll location every 5 seconds
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Tracking Location",
          content: "Updated at ${DateTime.now().toLocal()}",
        );
      }
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload(); // Ensure we get the latest values from main isolate
      
      final isOnline = prefs.getBool('is_online_tracking') ?? true;
      if (!isOnline) {
        print("DEV DEBUG - bg_location - User is OFFLINE. Stopping background tracking & system notification.");
        service.stopSelf();
        return;
      }

      final routeId = prefs.getString(BackgroundLocationService.routeIdKey);
      final cpId = prefs.getString(BackgroundLocationService.cpIdKey);
      final traversedStr = prefs.getString('bg_traversed_coords') ?? '[]';

      if (routeId != null && cpId != null) {
        print("DEV DEBUG - bg_location - Timer tick for routeId: $routeId");
        
        Position? position = latestPosition;
        if (position == null) {
          try {
            position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.bestForNavigation,
              timeLimit: const Duration(seconds: 5),
            );
            latestPosition = position;
          } catch (e) {
            print("DEV DEBUG - bg_location - No stream yet and getCurrentPosition timed out, using last known.");
            position = await Geolocator.getLastKnownPosition();
          }
        }

        if (position == null) {
          print("DEV DEBUG - bg_location - No GPS position available to send.");
          return;
        }
            
        final battery = Battery();
        final batteryLevel = await battery.batteryLevel;

        double lat = position.latitude;
        double lng = position.longitude;
        double speed = position.speed;
        double accuracy = position.accuracy;

        List<dynamic> traversed = jsonDecode(traversedStr);
        traversed.add([lng, lat]);
        await prefs.setString('bg_traversed_coords', jsonEncode(traversed));

        List<List<double>> traversedCoords = traversed.map((pt) => 
            [(pt[0] as num).toDouble(), (pt[1] as num).toDouble()]).toList();

        print("DEV DEBUG - bg_location - API Payload [5s interval]:");
        print(" -> lat: $lat, lng: $lng, speed: $speed, accuracy: $accuracy, battery: $batteryLevel");
        
        final apiService = ApiService();
        
        await apiService.updateLiveLocation(
          routeId: routeId,
          channelPartnerId: cpId,
          latitude: lat,
          longitude: lng,
          accuracy: accuracy,
          speed: speed,
          battery: batteryLevel.toDouble(),
        );

        print("DEV DEBUG - bg_location - Sending updateRoute with ${traversedCoords.length} path points");
        await apiService.updateRoute(
          routeId: routeId,
          channelPartnerId: cpId,
          coordinates: traversedCoords,
        );
        print("DEV DEBUG - bg_location - Live updates sent successfully.");
      } else {
        print("DEV DEBUG - bg_location - Missing routeId ($routeId) or cpId ($cpId)");
      }
    } catch (e) {
      print("DEV DEBUG - bg_location - Error: $e");
    }
  });
}
