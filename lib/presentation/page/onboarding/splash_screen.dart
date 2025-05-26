import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bewise/core/utils/sessionmanager.dart';
import 'package:bewise/presentation/page/home/main_screen.dart';
import 'package:bewise/presentation/page/onboarding/landing_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SessionManager _sessionManager = SessionManager();

  @override
  void initState() {
    super.initState();
    _navigateBasedOnLogin();
  }

  void _navigateBasedOnLogin() async {
    try {
      await Future.delayed(const Duration(seconds: 2));
      
      // Cek validitas token
      final isLoggedIn = await _sessionManager.isLoggedIn();
      
      // Navigate ke halaman yang sesuai
      if (mounted) {
        if (isLoggedIn) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LandingPage()),
          );
        }
      }
    } catch (e) {
      // Handle errors by going to landing page
      print('Error navigating: $e');
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LandingPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset(
          'assets/img/splashscreen.svg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}