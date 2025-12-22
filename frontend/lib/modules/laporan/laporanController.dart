import 'package:flutter/material.dart';
import 'package:kasir/modules/laporan/laporanModel.dart';
import 'package:kasir/modules/transaction/transactionController.dart';
import 'package:kasir/modules/transaction/transactionModel.dart';

class LaporanController extends ChangeNotifier {
  late TransactionController _transactionController;

  void setTransactionController(TransactionController controller) {
    _transactionController = controller;
  }

  bool _isLoading = false;
  String? _errorMessage;
  List<Laporan> _laporanData = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Laporan> get laporanData => _laporanData;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _errorMessage = value;
    notifyListeners();
  }

  void _setLaporanData(List<Laporan> value) {
    _laporanData = value;
    notifyListeners();
  }

  /* =========================
   * LAPORAN HARIAN
   * ========================= */
  Future<void> getLaporanHarian() async {
    try {
      _setLoading(true);

      await _transactionController.getTodayTransactions();
      final List<Transactionmodel> response =
          _transactionController.todayTransactions;

      final today = DateTime.now();

      final List<Laporan> data = response
          .map(
            (t) => Laporan(
              id: t.id!,
              createdAt: t.createdAt,
              invoiceNumber: t.invoiceNumber ?? '-',
              customerName: t.customerName ?? '-',
              paymentMethod: t.paymentMethod ?? '-',
              paymentStatus: t.paymentStatus ?? '-',
              note: t.note ?? '',
              totalAmount: (t.totalAmount ?? 0).toDouble(),
            ),
          )
          .toList();

      _setError(null);
      _setLaporanData(data);
    } catch (e) {
      _setError(e.toString());
      _setLaporanData([]);
    } finally {
      _setLoading(false);
    }
  }

  /* =========================
   * LAPORAN MINGGUAN
   * ========================= */
  Future<void> getLaporanMingguan() async {
    try {
      _setLoading(true);

      await _transactionController.getWeeklyTransactions();
      final Map<String, dynamic>? response =
          _transactionController.weeklySummary;

      if (response == null || response['data'] == null) {
        _setError('Data weekly kosong');
        _setLaporanData([]);
        return;
      }

      final List<Laporan> data = (response['data'] as List)
          .map((e) => Laporan.fromJson(e))
          .toList();

      _setError(null);
      _setLaporanData(data);
    } catch (e) {
      _setError(e.toString());
      _setLaporanData([]);
    } finally {
      _setLoading(false);
    }
  }

  /* =========================
   * LAPORAN BULANAN
   * ========================= */
  Future<void> getLaporanBulanan() async {
    try {
      _setLoading(true);

      await _transactionController.getMounlySummary();
      final Map<String, dynamic>? response =
          _transactionController.mounlySummary;

      if (response == null || response['data'] == null) {
        _setError('Data monthly kosong');
        _setLaporanData([]);
        return;
      }

      final List<Laporan> data = (response['data'] as List)
          .map((e) => Laporan.fromJson(e))
          .toList();

      _setError(null);
      _setLaporanData(data);
    } catch (e) {
      _setError(e.toString());
      _setLaporanData([]);
    } finally {
      _setLoading(false);
    }
  }
}
