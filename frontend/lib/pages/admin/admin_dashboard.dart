import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ======== HEADER — FIXED =======
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        AssetImage('assets/images/avatar.png'),
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

            const SizedBox(height: 10),

            // ======= SCROLL AREA ========
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ======= CARD STATISTIK =======
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _buildStatCard(
                            icon: Icons.shopping_cart_outlined,
                            title: "Total Orders",
                            value: "128",
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 12),
                          _buildStatCard(
                            icon: Icons.attach_money,
                            title: "Pendapatan",
                            value: "Rp 4.2 JT",
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ======= GRAFIK =======
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Grafik Penjualan Mingguan",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 14),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: 6,
                              minY: 0,
                              maxY: 20,
                              gridData: FlGridData(show: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      const days =
                                          ["S", "S", "R", "K", "J", "S", "M"];
                                      return Text(days[value.toInt()],
                                          style: const TextStyle(
                                              color: Colors.black));
                                    },
                                  ),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  isCurved: true,
                                  color: Colors.blue,
                                  barWidth: 3,
                                  dotData: FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.blue.withOpacity(0.2),
                                  ),
                                  spots: const [
                                    FlSpot(0, 4),
                                    FlSpot(1, 8),
                                    FlSpot(2, 12),
                                    FlSpot(3, 10),
                                    FlSpot(4, 14),
                                    FlSpot(5, 18),
                                    FlSpot(6, 16),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ======= MENU TERLARIS =======
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Menu Terlaris",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    _buildBestSeller(),
                    _buildBestSeller(),
                    _buildBestSeller(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ======= COMPONENT CARD STATISTIK =======
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
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
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
            Text(
              title,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

// ======= COMPONENT MENU TERLARIS =======
  Widget _buildBestSeller() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: const ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/images/avatar.png"),
          ),
          title: Text(
            "Ayam Geprek Sambal",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Terjual 86 kali",
              style: TextStyle(color: Colors.black)),
          trailing: Icon(Icons.chevron_right_rounded,
              size: 28, color: Colors.black),
        ),
      ),
    );
  }
}