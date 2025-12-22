import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kasir/modules/transaction/transactionModel.dart';
import 'package:kasir/modules/transaction/transactionService.dart';

class TransactionController extends ChangeNotifier {
  final TransactionService service = TransactionService();

  /// STATE
  List<Transactionmodel> transactions = [];
  List<Transactionmodel> todayTransactions = [];
  List<Map<String, dynamic>> bestSelling = [];

  Map<String, dynamic>? weeklySummary;
  Map<String, dynamic>? transactionDetail;
  Map<String, dynamic>? mounlySummary;

  int totalOrders = 0;
  double totalRevenue = 0;
  List<FlSpot> monthlyChart = [];

  bool isLoading = false;
  String? errorMessage;

  /// ================= GET ALL =================
  Future<void> getTransactions() async {
    try {
      isLoading = true;
      notifyListeners();

      transactions = await service.fetchTransactions();
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= GET BY ID =================
  Future<void> getTransactionById(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      transactionDetail = await service.fetchTransactionById(id);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= CREATE =================
  Future<void> createTransaction(Map<String, dynamic> payload) async {
    try {
      isLoading = true;
      notifyListeners();

      await service.createTransaction(payload);
      await getTransactions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= UPDATE =================
  Future<void> updateTransaction(int id, Map<String, dynamic> payload) async {
    try {
      isLoading = true;
      notifyListeners();

      await service.updateTransaction(id, payload);
      await getTransactions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= DELETE =================
  Future<void> deleteTransaction(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      await service.deleteTransaction(id);
      await getTransactions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= TODAY =================
  Future<void> getTodayTransactions() async {
    print('🔥 CONTROLLER DIPANGGIL');
    try {
      isLoading = true;
      notifyListeners();

      todayTransactions = await service.fetchTodayTransactions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= WEEKLY =================
  Future<void> getWeeklyTransactions() async {
    try {
      isLoading = true;
      notifyListeners();

      weeklySummary = await service.fetchWeeklyTransactions();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= Mounly =================
  Future<void> getMounlySummary() async {
    try {
      isLoading = true;
      notifyListeners();
      mounlySummary = await service.fetchMonthlySummary();
      totalOrders = mounlySummary?['totalTransaction'] ?? 0;
      totalRevenue = double.parse(
        mounlySummary?['totalIncome']?.toString() ?? '0',
      );
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= BEST SELLING =================
  Future<void> getBestSelling() async {
    try {
      isLoading = true;
      notifyListeners();

      bestSelling = await service.fetchBestSelling();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// ================= DASHBOARD =================
  Future<void> getDashboard() async {
    try {
      isLoading = true;
      notifyListeners();

      final summary = await service.fetchMonthlySummary();
      final chart = await service.fetchMonthlyChart();

      totalOrders = summary['totalTransaction'];
      totalRevenue = double.parse(summary['totalIncome'].toString());

      monthlyChart = List.generate(
        chart.length,
        (i) => FlSpot(i.toDouble(), (chart[i]['income'] as num).toDouble()),
      );

      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
