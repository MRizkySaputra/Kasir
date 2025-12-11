import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir/models/menu_model.dart'; // Pastikan import model Product/OrderItem

// Model untuk satu Transaksi Order
class OrderModel {
  final String id;
  final String table;
  final String customer;
  final String date;
  final String time;
  final String status;
  final List<OrderItem> items;
  final double tax;
  final double total;
  final double cash;
  final double change;

  OrderModel({
    required this.id,
    required this.table,
    required this.customer,
    required this.date,
    required this.time,
    required this.status,
    required this.items,
    required this.tax,
    required this.total,
    required this.cash,
    required this.change,
  });
}

class OrderController extends ChangeNotifier {
  final List<OrderModel> _orders = [];

  List<OrderModel> get orders => List.unmodifiable(_orders);

  // Fungsi menambah order baru
  void addOrder({
    required String customerName,
    required String tableNumber,
    required String status,
    required List<OrderItem> items,
    required double tax,
    required double total,
    double cash = 0,
    double change = 0,
  }) {
    final now = DateTime.now();
    
    final newOrder = OrderModel(
      id: "${now.millisecondsSinceEpoch}".substring(8),
      table: tableNumber,
      customer: customerName,
      date: DateFormat('EEE, MMMM d, yyyy').format(now),
      time: DateFormat('hh.mm a').format(now),
      status: status,
      items: List.from(items),
      tax: tax,
      total: total,
      cash: cash,
      change: change,
    );

    // Tambahkan ke urutan paling atas (terbaru)
    _orders.insert(0, newOrder);
    notifyListeners();
  }
}