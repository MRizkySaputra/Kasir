import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:kasir/auth/role.dart';

import 'package:kasir/themes/app_themes.dart';
import 'package:provider/provider.dart';

import 'laporanController.dart';
import 'laporanModel.dart';

// Dummy warna dan style (ganti sesuai project kamu)
const Color bgGrey = Color(0xFFF5F5F5);
const Color color = primaryGreen;

class LaporanView extends StatefulWidget {
  final UserRole role;

  const LaporanView({Key? key, required this.role}) : super(key: key);

  @override
  State<LaporanView> createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> {
  late final List<String> filters;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.role == UserRole.kasir) {
      filters = ['Harian'];
    } else {
      filters = ['Harian', 'Mingguan', 'Bulanan'];
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<LaporanController>();

      if (widget.role == UserRole.kasir) {
        controller.getLaporanHarian();
      } else {
        if (selectedIndex == 0) {
          controller.getLaporanHarian();
        } else if (selectedIndex == 1) {
          controller.getLaporanMingguan();
        } else {
          controller.getLaporanBulanan();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, controller, _) {
        final controller = context.watch<LaporanController>();
        return Scaffold(
          backgroundColor: bgGrey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Laporan Penjualan',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.black),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildFilterKategori(controller),
                const SizedBox(height: 16),
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.errorMessage != null) {
                        return Center(
                          child: Text('Error: ${controller.errorMessage}'),
                        );
                      }

                      final List<Laporan> data = controller.laporanData;

                      final double totalPendapatan = data.fold(
                        0,
                        (sum, item) => sum + item.totalAmount,
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Ringkasan',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _summaryItem(
                                        'Transaksi',
                                        data.length.toString(),
                                      ),
                                      _summaryItem(
                                        'Pendapatan',
                                        'Rp ${NumberFormat('#,###').format(totalPendapatan)}',
                                      ),
                                    ],
                                  ),
                                  if (widget.role == 'kasir')
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: primaryGreen,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                          onPressed: _showClosingDialog,
                                          child: const Text(
                                            'Closing Hari Ini',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: data.isEmpty
                                ? const Center(child: Text('Tidak ada data'))
                                : ListView.builder(
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      final item = data[index];
                                      return Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        elevation: 1.5,
                                        margin: const EdgeInsets.only(
                                          bottom: 8,
                                        ),
                                        child: ListTile(
                                          leading: const Icon(
                                            Icons.receipt_long,
                                          ),
                                          title: Text(
                                            'Rp ${NumberFormat('#,###').format(item.totalAmount)}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          subtitle: Text(
                                            DateFormat(
                                              'dd MMM yyyy • HH:mm',
                                            ).format(item.createdAt),
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                          onTap: () {
                                            // Buka detail (implementasi sesuai kebutuhan)
                                          },
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterKategori(LaporanController controller) {
    return Row(
      children: List.generate(filters.length, (index) {
        final isActive = selectedIndex == index;
        return Expanded(
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });

              if (index == 0) {
                controller.getLaporanHarian();
              } else if (index == 1) {
                controller.getLaporanMingguan();
              } else {
                controller.getLaporanBulanan();
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? primaryGreen : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                filters[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isActive ? Colors.white : primaryGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _summaryItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  void _showClosingDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Closing Harian'),
        content: const Text(
          'Apakah kamu yakin ingin melakukan closing hari ini?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Closing harian berhasil (dummy)'),
                ),
              );
            },
            child: const Text('Ya, Closing'),
          ),
        ],
      ),
    );
  }
}
