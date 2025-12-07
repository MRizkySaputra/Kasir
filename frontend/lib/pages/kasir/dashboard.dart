import 'package:flutter/material.dart';
import 'package:kasir/themes/app_themes.dart';

class KasirDashboardPage extends StatelessWidget {
  const KasirDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage('assets/images/avatar.png'),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Hallo Admin',
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      Text(
                        'Selamat Datang 👋',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // ISI DASHBOARD (KOSONG / PLACEHOLDER)
            const Expanded(
              child: Center(
                child: Text("Halaman Dashboard (Chart dll)"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}