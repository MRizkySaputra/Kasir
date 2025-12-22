import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir/modules/menu/menuModel.dart';
import 'package:kasir/modules/transaction/transactionController.dart';
import 'package:provider/provider.dart';

class OrderDetailSheet extends StatefulWidget {
  final List<CartItem> cart;
  final int total;
  final NumberFormat currencyFormatter;
  final VoidCallback onClearCart;

  const OrderDetailSheet({
    Key? key,
    required this.cart,
    required this.total,
    required this.currencyFormatter,
    required this.onClearCart,
  }) : super(key: key);

  @override
  State<OrderDetailSheet> createState() => _OrderDetailSheetState();
}

class _OrderDetailSheetState extends State<OrderDetailSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String _paymentMethod = 'Cash';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildPayload() {
    final tax = (widget.total * 0.03).round();
    final grandTotal = widget.total + tax;

    return {
      "customer_name": _nameController.text.trim(),
      "total_amount": grandTotal,
      "payment_method": _paymentMethod,
      "payment_status": "di proses",
      "note": _noteController.text.trim(),
      "items": widget.cart.map((item) {
        return {
          "product_id": item.product.id,
          "qty": item.quantity,
          "price": item.product.price.toInt(),
          "subtotal": (item.product.price * item.quantity).toInt(),
        };
      }).toList(),
    };
  }

  Future<void> _submitOrder(BuildContext context) async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama pelanggan wajib diisi")),
      );
      return;
    }

    setState(() => _isLoading = true);

    final controller = context.read<TransactionController>();

    try {
      final payload = _buildPayload();

      debugPrint("=== PAYLOAD ===");
      debugPrint(const JsonEncoder.withIndent('  ').convert(payload));

      await controller.createTransaction(payload);

      widget.onClearCart();
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesanan berhasil dikirim!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// DRAG HANDLE
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),

          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Detail Order",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Chip(
                label: const Text("Dine in"),
                backgroundColor: Colors.grey[200],
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// NAMA PELANGGAN
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: "Nama Pelanggan",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// PAYMENT METHOD
          DropdownButtonFormField<String>(
            value: _paymentMethod,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            items: const [
              DropdownMenuItem(value: 'Cash', child: Text('Cash')),
              DropdownMenuItem(value: 'QRIS', child: Text('QRIS')),
              DropdownMenuItem(value: 'Debit', child: Text('Debit')),
            ],
            onChanged: (value) {
              setState(() => _paymentMethod = value!);
            },
          ),

          const SizedBox(height: 12),

          /// NOTE
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Catatan (opsional)",
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// CART LIST
          Expanded(
            child: ListView.separated(
              itemCount: widget.cart.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = widget.cart[index];

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.product.image ?? '',
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 48,
                              height: 48,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.currencyFormatter.format(
                                item.product.price,
                              ),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "x${item.quantity}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// SUMMARY
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                _summaryRow("Sub Total", widget.total),
                _summaryRow("Tax 3%", (widget.total * 0.03).round()),
                const Divider(),
                _summaryRow(
                  "Total Payment",
                  widget.total + (widget.total * 0.03).round(),
                  bold: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          /// BUTTON
          ElevatedButton(
            onPressed: _isLoading ? null : () => _submitOrder(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Pay Now",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String title, int value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            widget.currencyFormatter.format(value),
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

/// CART ITEM
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}
