import 'package:flutter/material.dart';
import 'package:kasir/themes/app_themes.dart';
import 'package:kasir/models/menu_model.dart';
import 'package:kasir/pages/payment/bill_page.dart';

class PaymentSuccessPage extends StatelessWidget {
  final List<OrderItem> cart;
  final double total;
  final double cash;
  final double change;
  final String customerName;

  const PaymentSuccessPage({
    super.key,
    required this.cart,
    required this.total,
    required this.cash,
    required this.change,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Payment"), backgroundColor: Colors.white, elevation: 0),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.black,
              child: Icon(Icons.check, color: Colors.white, size: 60),
            ),
            const SizedBox(height: 24),
            const Text(
              "Payment Success",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Continue (Balik ke Menu)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    // Kembali ke dashboard dan hapus history route pembayaran
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Continue", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
                // Tombol See Bills
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillPage(
                          cart: cart,
                          total: total,
                          cash: cash,
                          change: change,
                          customerName: customerName,
                        ),
                      ),
                    );
                  },
                  child: const Text("See Bills", style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}