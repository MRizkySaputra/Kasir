import 'package:flutter/material.dart';
import 'package:kasir/auth/role.dart';
import 'package:kasir/modules/laporan/laporanView.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LaporanView(role: UserRole.kasir);
  }
}
