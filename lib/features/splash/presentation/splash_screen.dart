import 'package:flutter/material.dart';
import 'package:uk_circle_partners/core/thems/app_colors.dart';
import 'dart:async';
import '../../../core/utils/session_manager.dart';
import '../../auth/presentation/login_screen.dart';
import '../../home/presentation/main_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() {
    Timer(Duration(seconds: 2), () {
      if (mounted) {
        if (SessionManager.isLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colors.cardBackground,
      body: SafeArea(
        child: Column(
          children: [
            Spacer(flex: 2),
            // Logo area
            Container(
              padding: EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blueGrey.withValues(alpha: 0.1),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.groups, size: 64, color: Color(0xFF1B365D)),
                  SizedBox(height: 8),
                  Text(
                    'UDYAMI\nCIRCLE',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1B365D),
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48),
            Text(
              'Channel Partner App',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B365D),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Grow together, Earn together',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1B365D),
              ),
            ),
            Spacer(flex: 3),
            // Illustration placeholder
            Container(
              height: 200,
              width: double.infinity,
              color: context.colors.cardBackground, // In a real app, you would use an Image.asset here
              child: Icon(
                Icons.handshake,
                size: 100,
                color: Colors.blueGrey,
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
