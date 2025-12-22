import 'package:flutter/material.dart';
import 'package:kasir/modules/transaction/transactionController.dart';
import 'package:kasir/modules/transaction/transactionModel.dart';
import 'package:kasir/modules/transaction/transactionDetailModel.dart';
import 'package:kasir/pages/payment/payment_success_page.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final Transactionmodel transaction;
  final List<TransactionDetail> items;
  final double subtotal;
  final double tax;
  final double total;
  final String customerName;

  const PaymentPage({
    super.key,
    required this.transaction,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.customerName,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final TextEditingController _cashController = TextEditingController();

  @override
  void dispose() {
    _cashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // =======================
            // LIST ITEM TRANSAKSI
            // =======================
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];

                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      "Product ID ${item.productId}",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text("Qty: ${item.qty}"),
                    trailing: Text("Rp ${item.subtotal}"),
                  );
                },
              ),
            ),

            const Divider(),

            // =======================
            // RINGKASAN HARGA
            // =======================
            _priceRow("Subtotal", widget.subtotal),
            _priceRow("Tax", widget.tax),
            _priceRow("Total", widget.total, bold: true),

            const SizedBox(height: 16),

            // =======================
            // INPUT CASH
            // =======================
            TextField(
              controller: _cashController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Cash",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // =======================
            // BUTTON PAY
            // =======================
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handlePay,
                child: const Text("Pay Now"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =======================
  // HANDLE PAY LOGIC
  // =======================
  Future<void> _handlePay() async {
    final cash = double.tryParse(_cashController.text) ?? 0;

    if (cash <= 0) {
      _showMessage("Masukkan nominal cash");
      return;
    }

    if (cash < widget.total) {
      _showMessage("Uang tidak cukup");
      return;
    }

    final change = cash - widget.total;
    final payload = {"payment_status": "selesai"};
    try {
      // ⏳ TUNGGU UPDATE STATUS KE BACKEND
      await context.read<TransactionController>().updateTransaction(
        widget.transaction.id,
        payload,
      );

      // ✅ JIKA BERHASIL → PINDAH KE BILL
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => PaymentSuccessPage(
            transaction: widget.transaction,
            items: widget.items,
            total: widget.total,
            cash: cash,
            change: change,
            customerName: widget.customerName,
          ),
        ),
      );
    } catch (e) {
      // ❌ JIKA GAGAL
      _showMessage("Gagal menyelesaikan transaksi");
    }
  }

  // =======================
  // UI HELPERS
  // =======================
  Widget _priceRow(String label, double value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            "Rp ${value.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
