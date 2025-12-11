import 'package:flutter/material.dart';
import 'package:kasir/pages/kasir/account.dart';
import 'package:kasir/pages/kasir/dashboard.dart';
import 'package:kasir/pages/kasir/menu_page.dart';
import 'package:kasir/pages/kasir/order_page.dart';
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
    AccountPage(),
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
      ),
    );
  }
}