import 'package:flutter/material.dart';
import 'package:kasir/pages/admin/admin_dashboard.dart';
import 'package:kasir/pages/menu_page.dart';
import 'package:kasir/widgets/buttom_navigation.dart';

class DashboardWrapper extends StatefulWidget {
  const DashboardWrapper({super.key});

  @override
  State<DashboardWrapper> createState() => _DashboardWrapperState();
}

class _DashboardWrapperState extends State<DashboardWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardPage(),
    MenuPage(),
    // OrderPage(),
    // AccountPage(),
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