import 'package:flutter/material.dart';
import 'package:kasir/auth/roleProvider.dart';
import 'package:kasir/modules/laporan/laporanController.dart';

import 'package:kasir/modules/menu/menuControllers.dart';
import 'package:kasir/modules/transaction/transactionController.dart';
import 'package:kasir/modules/users/userController.dart';
import 'package:provider/provider.dart';
import 'package:kasir/themes/app_themes.dart';
import 'package:kasir/pages/splash_screen.dart';
import 'package:kasir/auth/login_page.dart';
import 'package:kasir/pages/admin/admin_wrapper.dart';
import 'package:kasir/pages/kasir/kasir_wrapper.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductControllers()),
        ChangeNotifierProvider(create: (_) => TransactionController()),
        ChangeNotifierProvider(create: (_) => UserController()..fetchUsers()),
        ChangeNotifierProvider(create: (_) => RoleProvider()),
        ChangeNotifierProxyProvider<TransactionController, LaporanController>(
          create: (_) => LaporanController(),
          update: (_, transactionController, laporanController) {
            laporanController!.setTransactionController(transactionController);
            return laporanController;
          },
        ),
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
