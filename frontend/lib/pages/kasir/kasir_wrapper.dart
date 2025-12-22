import 'package:flutter/material.dart';
import 'package:kasir/auth/role.dart';
import 'package:kasir/pages/kasir/kasir_dashboard.dart';
import 'package:kasir/pages/kasir/kasir_laporan.dart';
import 'package:kasir/pages/kasir/kasir_menu.dart';
import 'package:kasir/pages/kasir/kasir_order.dart';
import 'package:kasir/widgets/buttom_navigation.dart';

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({super.key});

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    KasirDashboardPage(),
    MenuPage(),
    OrderPage(),
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
        role: UserRole.kasir,
      ),
    );
  }
}
