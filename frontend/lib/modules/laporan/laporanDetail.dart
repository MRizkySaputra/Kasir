import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:kasir/modules/laporan/laporanModel.dart';
import 'package:kasir/themes/app_textstyle.dart';
import 'package:kasir/themes/app_themes.dart';

class LaporanDetailPage extends StatelessWidget {
  final Laporan laporan;
  final LaporanResult result;

  const LaporanDetailPage({
    super.key,
    required this.laporan,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    // Dummy Item Pesanan
    final List<Map<String, dynamic>> items = [
      {'name': 'Nasi Goreng', 'qty': 2, 'price': 20000},
      {'name': 'Es Teh', 'qty': 1, 'price': 5000},
    ];

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Detail Laporan',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Informasi Transaksi
            _buildSection(
              title: 'Informasi Transaksi',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('Invoice', 'INV-001'),
                  _infoRow(
                    'Tanggal',
                    DateFormat('dd MMM yyyy • HH:mm').format(laporan.createdAt),
                  ),
                  _infoRow('Kasir', 'Admin'),
                  _infoRow('Customer', 'Meja 5'),
                  _infoRow('Status', 'Selesai', valueColor: primaryGreen),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Item Pesanan
            _buildSection(
              title: 'Item Pesanan',
              child: Column(
                children: items.map((item) {
                  final subtotal = item['qty'] * item['price'];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item['name']} x${item['qty']}',
                            style: AppTextStyle.bodyMedium,
                          ),
                        ),
                        Text(
                          'Rp ${NumberFormat('#,###').format(subtotal)}',
                          style: AppTextStyle.bodyMedium,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 16),

            // Ringkasan Pembayaran
            _buildSection(
              title: 'Ringkasan Pembayaran',
              child: Column(
                children: [
                  _priceRow('Subtotal', result.totalIncome),
                  _priceRow('Metode Bayar', 0, isText: true, text: 'Cash'),
                  const Divider(height: 24),
                  _priceRow('Total', laporan.totalAmount, isTotal: true),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section Card

  Widget _buildSection({required String title, required Widget child}) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyle.bodyLarge),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyle.bodyMedium),
          Text(
            value,
            style: AppTextStyle.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _priceRow(
    String label,
    double value, {
    bool isTotal = false,
    bool isText = false,
    String? text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal ? AppTextStyle.bodyLarge : AppTextStyle.bodyMedium,
          ),
          isText
              ? Text(text ?? '', style: AppTextStyle.bodyMedium)
              : Text(
                  'Rp ${NumberFormat('#,###').format(value)}',
                  style: isTotal
                      ? AppTextStyle.bodyLarge.copyWith(
                          fontWeight: FontWeight.bold,
                        )
                      : AppTextStyle.bodyMedium,
                ),
        ],
      ),
    );
  }
}
