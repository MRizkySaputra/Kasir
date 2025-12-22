import 'package:flutter/material.dart';
import 'package:kasir/auth/role.dart';
import 'package:kasir/pages/admin/admin_account.dart';
import 'package:kasir/pages/admin/admin_laporan.dart';
import 'package:kasir/pages/admin/admin_orders.dart';
import 'package:kasir/pages/admin/admin_dashboard.dart';
import 'package:kasir/pages/admin/admin_menu.dart';
import 'package:kasir/widgets/buttom_navigation.dart';

class AdminWrapper extends StatefulWidget {
  const AdminWrapper({super.key});

  @override
  State<AdminWrapper> createState() => _AdminWrapperState();
}

class _AdminWrapperState extends State<AdminWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    MenuPage(),
    OrderPage(),
    AccountPage(),
    LaporanPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        role: UserRole.admin,
      ),
    );
  }
}
