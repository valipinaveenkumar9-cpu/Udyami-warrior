import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'package:flutter/services.dart';
import 'package:uk_circle_partners/features/auth/presentation/login_screen.dart';
import 'features/expo/presentation/expo_registration_form_screen.dart';
import 'core/utils/session_manager.dart';
import 'core/services/background_location_service.dart';

final ValueNotifier<ThemeMode> appThemeNotifier = ValueNotifier(ThemeMode.light);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionManager.init();
  await BackgroundLocationService().initializeService();
  
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
    ),
  );
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Uri? uri;
    try {
      uri = Uri.base;
    } catch (_) {}

    final bool isExpoRegister = uri != null && (uri.path.contains('expo/register') || uri.queryParameters.containsKey('ref') || uri.fragment.contains('ref='));
    String? refCode = uri?.queryParameters['ref'];
    if (refCode == null && uri != null && uri.fragment.contains('ref=')) {
      try {
        final fragUri = Uri.parse('https://dummy/${uri.fragment}');
        refCode = fragUri.queryParameters['ref'];
      } catch (_) {}
    }

    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Channel Partner App',
          debugShowCheckedModeBanner: false,
          themeMode: ThemeMode.light,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0E5C4A),
              brightness: Brightness.light,
              background: const Color(0xFFFAFAFA),
              surface: context.colors.cardBackground,
              onBackground: const Color(0xFF0F172A),
              onSurface: const Color(0xFF0F172A),
            ),
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            appBarTheme: AppBarTheme(
              backgroundColor: context.colors.cardBackground,
              foregroundColor: Color(0xFF0F172A),
              elevation: 0,
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
            extensions: <ThemeExtension<dynamic>>[
              AppColors.dark,
            ],
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF0E5C4A),
              brightness: Brightness.dark,
              background: const Color(0xFF0F172A),
              surface: const Color(0xFF1E293B),
              onBackground: const Color(0xFFF8FAFC),
              onSurface: const Color(0xFFF8FAFC),
            ),
            scaffoldBackgroundColor: const Color(0xFF0F172A),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E293B),
              foregroundColor: Color(0xFFF8FAFC),
              elevation: 0,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              backgroundColor: Color(0xFF1E293B),
              selectedItemColor: Color(0xFF0E5C4A),
              unselectedItemColor: Color(0xFF94A3B8),
            ),
            useMaterial3: true,
            fontFamily: 'Roboto',
            extensions: <ThemeExtension<dynamic>>[
              AppColors.dark,
            ],
          ),
          home: isExpoRegister ? ExpoRegistrationFormScreen(referralCode: refCode) : const LoginScreen(),
        );
      },
    );
  }
}
