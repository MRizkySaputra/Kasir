import 'package:flutter/material.dart';
import 'package:kasir/controllers/order_controller.dart';
import 'package:kasir/models/menu_model.dart';
import 'package:kasir/themes/app_themes.dart';
import 'package:kasir/pages/payment/payment_success_page.dart';
import 'package:provider/provider.dart';

class PaymentPage extends StatefulWidget {
  final List<OrderItem> cart;
  final double subtotal;
  final double tax;
  final double total;
  final String customerName;

  const PaymentPage({
    super.key,
    required this.cart,
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Payment",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ================= SUMMARY ORDER =================
            _buildSectionContainer(
              title: "Summary Order",
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.cart.length,
                separatorBuilder: (ctx, i) => const SizedBox(height: 12),
                itemBuilder: (ctx, i) {
                  final item = widget.cart[i];
                  return Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                          // image: DecorationImage(image: AssetImage(item.product.imageAsset), fit: BoxFit.cover),
                        ),
                        child: const Icon(
                          Icons.fastfood,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item.product.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      Text(
                        "x${item.quantity}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Rp ${item.total.toInt()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= PAYMENT METHOD =================
                Expanded(
                  child: _buildSectionContainer(
                    title: "Payment Method",
                    child: Column(
                      children: [
                        // Placeholder Payment Method Buttons
                        _paymentMethodOption("Cash", true),
                        const SizedBox(height: 8),
                        _paymentMethodOption("QRIS", false),
                        const SizedBox(height: 12),
                        // Input Uang Tunai
                        TextField(
                          controller: _cashController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Jumlah Uang Tunai",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixText: "Rp ",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // ================= PAYMENT DETAILS =================
                Expanded(
                  child: _buildSectionContainer(
                    title: "Payment Details",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _detailRow(
                          "Nama Pelanggan",
                          widget.customerName,
                          isHeader: true,
                        ),
                        const Divider(),
                        _detailRow(
                          "Sub Total",
                          "Rp ${widget.subtotal.toInt()}",
                        ),
                        _detailRow("Discount", "-"),
                        _detailRow("Tax 3%", "Rp ${widget.tax.toInt()}"),
                        const Divider(thickness: 1.5),
                        _detailRow(
                          "Total Payment",
                          "Rp ${widget.total.toInt()}",
                          isBold: true,
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryGreen,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // Validasi Input Uang
                              double cash =
                                  double.tryParse(_cashController.text) ?? 0;
                              if (cash < widget.total) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Uang tunai kurang!"),
                                  ),
                                );
                                return;
                              } 

                              double change = cash - widget.total;
                              context.read<OrderController>().addOrder(
                                customerName: widget.customerName,
                                tableNumber: "A1",
                                status: "Selesai",
                                items: widget.cart,
                                tax: widget.tax,
                                total: widget.total,
                                cash: cash,
                                change: change,
                              );

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PaymentSuccessPage(
                                    cart: widget.cart,
                                    total: widget.total,
                                    cash: cash,
                                    change: cash - widget.total,
                                    customerName: widget.customerName,
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              "Pay Bills",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer({
    required String title,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const Divider(color: Colors.black12, thickness: 1),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _paymentMethodOption(String label, bool isSelected) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        border: Border.all(color: isSelected ? primaryGreen : Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: primaryGreen, size: 20),
        ],
      ),
    );
  }

  Widget _detailRow(
    String label,
    String value, {
    bool isHeader = false,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: isHeader
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
    );
  }
}
