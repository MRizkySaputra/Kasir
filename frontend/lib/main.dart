import 'package:flutter/material.dart';
import 'package:kasir/pages/admin/admin_wrapper.dart';
import 'package:kasir/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'themes/app_themes.dart';
import 'controllers/menu_controllers.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MenuControllers()),
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
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginPage(),
        '/admin': (_) => const AdminWrapper(),
      },
    );
  }
}