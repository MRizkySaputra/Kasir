import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir/models/menu_model.dart';
import 'package:kasir/themes/app_themes.dart';

class BillPage extends StatelessWidget {
  final List<OrderItem> cart;
  final double total;
  final double cash;
  final double change;
  final String customerName;

  const BillPage({
    super.key,
    required this.cart,
    required this.total,
    required this.cash,
    required this.change,
    required this.customerName,
  });

  @override
  Widget build(BuildContext context) {
    // Format Waktu
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Bills", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: primaryGreen),
              onPressed: () {}, // Logic Print
              child: const Text("Print Bills", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFE0E0E0), // Abu-abu background struk
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- HEADER STRUK ---
              const Text("ABC", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              const SizedBox(height: 8),
              const Text("Alamat Toko: Jl. Mawar No 123", textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 20),
              const Divider(color: Colors.black),
              
              // --- INFO TRANSAKSI ---
              _infoRow("Nama Pelanggan", customerName),
              _infoRow("Waktu", formattedDate),
              _infoRow("Kasir", "Admin"),
              const SizedBox(height: 10),
              const Divider(color: Colors.black),

              // --- LIST ITEM ---
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cart.length,
                itemBuilder: (ctx, i) {
                  final item = cart[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("${item.quantity} ${item.product.name}", style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text("+ ${item.note.isEmpty ? 'Dine in' : item.note}", style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                        Text("Rp ${item.total.toInt()}"),
                      ],
                    ),
                  );
                },
              ),
              const Divider(color: Colors.black),

              // --- TOTALAN ---
              _priceRow("Subtotal ${cart.length} Produk", total * 100 / 103), // Estimasi reverse tax
              _priceRow("Tax", total * 3 / 103),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("Rp ${total.toInt()}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const Divider(color: Colors.black),

              // --- PEMBAYARAN ---
              _priceRow("Tunai", cash),
              _priceRow("Total Bayar", total),
              _priceRow("Kembalian", change),
              
              const SizedBox(height: 30),
              const Divider(color: Colors.black),
              const Center(child: Text("Terima Kasih", style: TextStyle(fontWeight: FontWeight.bold))),
              const Center(child: Text("Layanan Customer : 0812-3456-7890", style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("$label :"),
          Text(value),
        ],
      ),
    );
  }

  Widget _priceRow(String label, double value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text("Rp ${value.toInt()}"),
        ],
      ),
    );
  }
}