import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kasir/themes/app_themes.dart';
import 'package:kasir/controllers/order_controller.dart';
import 'package:kasir/widgets/order_card.dart';
import 'package:kasir/pages/payment/bill_page.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String _selectedTab = 'Semua';
  final List<String> _tabs = ['Semua', 'Proses', 'Selesai'];

  @override
  Widget build(BuildContext context) {
    final orderController = Provider.of<OrderController>(context);
    final allOrders = orderController.orders;

    final filteredOrders = _selectedTab == 'Semua'
        ? allOrders
        : allOrders.where((order) => order.status == _selectedTab).toList();

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Order", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Search Bar dan Filter
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search name, order id...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    suffixIcon: const Icon(Icons.tune, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tabs.map((tab) {
                      final bool isActive = _selectedTab == tab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = tab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                            decoration: BoxDecoration(
                              color: isActive ? primaryGreen : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: isActive ? primaryGreen : Colors.grey.shade300),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(color: isActive ? Colors.white : Colors.black, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // LIST VIEW DINAMIS
          Expanded(
            child: filteredOrders.isEmpty 
            ? Center(child: Text("Belum ada pesanan ${_selectedTab != 'Semua' ? '$_selectedTab' : ''}"))
            : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: filteredOrders.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final order = filteredOrders[index];
                
                // Konversi data untuk OrderCard (karena OrderCard menerima Map)
                final orderMap = {
                    'id': order.id,
                    'table': order.table,
                    'customer': order.customer,
                    'date': order.date,
                    'time': order.time,
                    'status': order.status,
                    'items': order.items.map((i) => {
                      'name': i.product.name,
                      'qty': i.quantity,
                      'price': i.product.price
                    }).toList(),
                    'tax': order.tax,
                    'total': order.total,
                };

                return OrderCard(
                  order: orderMap,
                  // NAVIGASI KE BILL PAGE
                  onPressedDetails: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BillPage(
                          cart: order.items,    
                          total: order.total,  
                          customerName: order.customer,
                          cash: order.cash == 0 ? order.total : order.cash, 
                          change: order.change,
                        ),
                      ),
                    );
                  },
                  onPressedAction: () {
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}