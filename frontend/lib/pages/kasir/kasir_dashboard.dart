import 'package:flutter/material.dart';
import 'package:kasir/widgets/calculator.dart';
import 'package:provider/provider.dart';
import 'package:kasir/modules/transaction/transactionController.dart';

class KasirDashboardPage extends StatefulWidget {
  const KasirDashboardPage({super.key});

  @override
  State<KasirDashboardPage> createState() => _KasirDashboardPageState();
}

class _KasirDashboardPageState extends State<KasirDashboardPage> {
  double _calculatorResult = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final controller = context.read<TransactionController>();
      controller.getMounlySummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionController>(
      builder: (context, controller, _) {
        if (controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// ===== STAT CARD =====
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              _buildStatCard(
                                icon: Icons.shopping_cart_outlined,
                                title: "Total Orders",
                                value: controller.totalOrders.toString(),
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 12),
                              _buildStatCard(
                                icon: Icons.attach_money,
                                title: "Pendapatan",
                                value:
                                    "Rp ${controller.totalRevenue.toStringAsFixed(0)}",
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ===== CALCULATOR =====
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: CalculatorWidget(
                            onResult: (result) {
                              setState(() {
                                _calculatorResult = result;
                              });
                            },
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// ===== RESULT INFO (OPTIONAL) =====
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "Hasil Kalkulator: Rp ${_calculatorResult.toStringAsFixed(0)}",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= WIDGET =================

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: const [
          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage('assets/images/avatar.png'),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Hallo Admin", style: TextStyle(fontSize: 14)),
              Text(
                "Selamat Datang 👋",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(title),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
