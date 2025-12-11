import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:kasir/auth/login_page.dart';
import 'package:kasir/themes/app_themes.dart';

class SplashGifPage extends StatelessWidget {
  const SplashGifPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterSplashScreen.gif(
        // Konfigurasi GIF
        gifPath: 'assets/animations/checkout.gif',
        gifWidth: 269,
        gifHeight: 474,
        
        // Konfigurasi Logika
        nextScreen: const LoginPage(),
        duration: const Duration(milliseconds: 3000),
        
        backgroundColor: primaryGreen,
        
        onInit: () async {
          debugPrint("Splash screen dimulai");
        },
        onEnd: () async {
          debugPrint("Splash screen selesai");
        },
      ),
    );
  }
}