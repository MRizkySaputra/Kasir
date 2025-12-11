import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kasir/themes/app_themes.dart';
import 'package:kasir/controllers/menu_controllers.dart';
import 'package:kasir/controllers/order_controller.dart';
import 'package:kasir/pages/splash_screen.dart';
import 'package:kasir/auth/login_page.dart';
import 'package:kasir/pages/admin/admin_wrapper.dart';
import 'package:kasir/pages/kasir/dashboard_wrapper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuControllers()),
        ChangeNotifierProvider(create: (_) => OrderController()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir App',
      theme: AppThemes.light,
      debugShowCheckedModeBanner: false,
      
      // Opsi 1: Gunakan home (Paling simpel untuk package ini)
      home: const SplashGifPage(), 
      
      // Opsi 2: Tetap pakai routes (Jika ingin konsisten dengan named routes)
      // initialRoute: '/splash',
      
      routes: {
        // '/splash': (_) => const SplashGifPage(), // Jika pakai Opsi 2
        '/login': (_) => const LoginPage(),
        '/admin': (_) => const AdminWrapper(),
        '/kasir': (_) => const DashboardWrapper(),
      },
    );
  }
}