import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir/themes/app_themes.dart';

class OrderCard extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback? onPressedDetails;
  final VoidCallback? onPressedAction;

  const OrderCard({
    super.key,
    required this.order,
    this.onPressedDetails,
    this.onPressedAction,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelesai = order['status'] == 'Selesai';

    // Formatter khusus untuk card ini
    final NumberFormat currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // HEADER: Meja, Nama, Status
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Badge Nomor Meja
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 12),
              // Info Customer
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            order['customer'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Badge Status
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isSelesai
                                ? Colors.green.shade100
                                : Colors.lightGreen.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            order['status'],
                            style: TextStyle(
                              color: isSelesai
                                  ? Colors.green.shade800
                                  : Colors.lightGreen.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "order #${order['id']}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Tanggal & Waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order['date'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                order['time'],
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const Divider(height: 24),

          // List Barang (Preview)
          Column(
            children: (order['items'] as List).map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Text(
                        item['name'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "x${item['qty']}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        currencyFormatter.format(item['price']),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const Divider(height: 24),

          // Total Harga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Tax",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const Text(
                    "Total",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    currencyFormatter.format(7000),
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    currencyFormatter.format(order['total']),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Tombol Aksi
          Row(
            children: [
              // Tombol See Details selalu ada
              Expanded(
                child: OutlinedButton(
                  onPressed: onPressedDetails,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: const Text(
                    "See Details",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Tombol Pay Bills hanya muncul kalau status bukan "Selesai"
              if (!isSelesai)
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPressedAction,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: secondaryYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Pay Bills",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
