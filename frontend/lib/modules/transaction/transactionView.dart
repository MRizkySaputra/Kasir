import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir/pages/payment/payment_bill.dart';
import 'package:kasir/pages/payment/payment_page.dart';
import 'package:provider/provider.dart';

import 'package:kasir/modules/transaction/transactionController.dart';
import 'package:kasir/themes/app_themes.dart';
import 'package:kasir/modules/transaction/widget/order_card.dart';
import 'package:kasir/widgets/searchbar.dart';

class Transactionview extends StatefulWidget {
  const Transactionview({super.key});

  @override
  State<Transactionview> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<Transactionview> {
  String _selectedTab = 'Semua';
  final List<String> _tabs = ['Semua', 'Proses', 'Selesai'];

  final TextEditingController _searchController = TextEditingController();
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<TransactionController>().getTodayTransactions();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<TransactionController>();

    /// LOADING
    if (controller.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    /// ERROR
    if (controller.errorMessage != null) {
      return Scaffold(body: Center(child: Text(controller.errorMessage!)));
    }

    final allOrders = controller.todayTransactions;

    /// FILTER BY TAB & SEARCH KEYWORD
    final filteredOrders = allOrders.where((tx) {
      final status = tx.paymentStatus.toLowerCase();

      // Filter berdasarkan tab
      final matchesStatus =
          _selectedTab == 'Semua' ||
          (_selectedTab == 'Proses' && status.contains('proses')) ||
          (_selectedTab == 'Selesai' && status.contains('selesai'));

      // Filter berdasarkan search keyword di nama customer atau id transaksi
      final matchesSearch =
          _searchKeyword.isEmpty ||
          tx.customerName.toLowerCase().contains(_searchKeyword) ||
          tx.id.toString().contains(_searchKeyword);

      return matchesStatus && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: bgGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Order",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          /// SEARCH + TAB
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Searchbar(
                  controller: _searchController,
                  hintText: 'Search name, order id...',
                  suffixIcon: _searchKeyword.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchKeyword = '');
                          },
                        )
                      : null,
                  onChanged: (value) {
                    setState(() {
                      _searchKeyword = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 16),

                /// TAB
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _tabs.map((tab) {
                      final isActive = _selectedTab == tab;
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedTab = tab),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: isActive ? primaryGreen : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isActive
                                    ? primaryGreen
                                    : Colors.grey.shade300,
                              ),
                            ),
                            child: Text(
                              tab,
                              style: TextStyle(
                                color: isActive ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
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

          /// LIST ORDER
          Expanded(
            child: filteredOrders.isEmpty
                ? Center(
                    child: Text(
                      "Belum ada pesanan ${_selectedTab != 'Semua' ? _selectedTab : ''}",
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final tx = filteredOrders[index];

                      final orderMap = {
                        'id': tx.id,
                        'table': '-',
                        'customer': tx.customerName,
                        'status':
                            tx.paymentStatus.toLowerCase().contains('proses')
                            ? 'Proses'
                            : 'Selesai',
                        'date': DateFormat('dd MMM yyyy').format(tx.createdAt),
                        'time': DateFormat('HH:mm').format(tx.createdAt),
                        'items': tx.items.map((i) {
                          return {
                            'name': 'Product ${i.productId}',
                            'qty': i.qty,
                            'price': i.price,
                          };
                        }).toList(),
                        'tax': 0,
                        'total': tx.totalAmount,
                      };

                      return OrderCard(
                        order: orderMap,

                        onPressedDetails: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BillPage(
                                transaction: tx,
                                items: tx.items,
                                total: tx.totalAmount.toDouble(),
                                customerName: tx.customerName,
                                cash: tx.totalAmount.toDouble(),
                                change: 0,
                              ),
                            ),
                          );
                        },

                        onPressedAction: () async {
                          final tax = tx.totalAmount * 0.03;
                          final subtotal = tx.totalAmount - tax;

                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentPage(
                                transaction: tx,
                                items: tx.items,
                                subtotal: subtotal,
                                tax: tax,
                                total: tx.totalAmount.toDouble(),
                                customerName: tx.customerName,
                              ),
                            ),
                          );
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
