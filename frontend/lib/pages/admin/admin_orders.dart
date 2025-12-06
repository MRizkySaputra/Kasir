import 'package:flutter/material.dart';
import '../../themes/app_textstyle.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String _search = "";

  // dummy data
  final List<Map<String, dynamic>> _orders = [
    {"id": "001", "customer": "Asep", "menu": "Nasi Goreng", "qty": 2, "total": 30000, "status": "Selesai"},
    {"id": "002", "customer": "Budi", "menu": "Es Teh", "qty": 1, "total": 6000, "status": "Pending"},
    {"id": "003", "customer": "Siti", "menu": "Ayam Geprek", "qty": 1, "total": 18000, "status": "Selesai"},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _orders.where((o) {
      if (_search.trim().isEmpty) return true;
      final q = _search.toLowerCase();
      return o["customer"].toString().toLowerCase().contains(q) ||
          o["menu"].toString().toLowerCase().contains(q) ||
          o["id"].toString().toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Orders")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // search
            TextField(
              decoration: InputDecoration(
                hintText: "Cari order...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(context).cardColor,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),

            const SizedBox(height: 12),

            // table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text("ID")),
                    DataColumn(label: Text("Customer")),
                    DataColumn(label: Text("Menu")),
                    DataColumn(label: Text("Qty")),
                    DataColumn(label: Text("Total")),
                    DataColumn(label: Text("Status")),
                  ],
                  rows: filtered.map((o) {
                    return DataRow(cells: [
                      DataCell(Text(o["id"].toString())),
                      DataCell(Text(o["customer"].toString())),
                      DataCell(Text(o["menu"].toString())),
                      DataCell(Text(o["qty"].toString())),
                      DataCell(Text("Rp ${o["total"]}")),
                      DataCell(_statusChip(o["status"].toString())),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(String status) {
    final color = status.toLowerCase() == "selesai" ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: color.withOpacity(.15), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: AppTextStyle.withColor(AppTextStyle.bodySmall, color)),
    );
  }
}
