import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kasir/error/apiException.dart';
import 'package:kasir/error/apiHelper.dart';
import 'package:kasir/modules/transaction/transactionModel.dart';

class TransactionService {
  static final _storage = const FlutterSecureStorage();
  final String baseUrl =
      'https://kasir-git-main-agungs-projects-5080770e.vercel.app/api/v1';

  /// ================= GET LIST =================
  Future<List<Transactionmodel>> fetchTransactions() async {
    final token = await _storage.read(key: 'token');
    final res = await Apihelper.safeGet('/transaction', token);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List data = body['result']['data'];
      return data.map((e) => Transactionmodel.fromJson(e)).toList();
    }

    throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
  }

  /// ================= GET BY ID =================
  Future<Map<String, dynamic>> fetchTransactionById(int id) async {
    final token = await _storage.read(key: 'token');
    final res = await Apihelper.safeGet('/transactions/$id', token);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body['result'];
    }

    throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
  }

  /// ================= CREATE =================
  Future<void> createTransaction(Map<String, dynamic> payload) async {
    final token = await _storage.read(key: 'token');
    final res = await http.post(
      Uri.parse('$baseUrl/transaction'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );
    print('STATUS: ${res.statusCode}');
    print('BODY: ${res.body}');

    if (res.statusCode != 201 && res.statusCode != 200) {
      throw Exception('Gagal membuat transaksi');
    }
  }

  /// ================= UPDATE =================
  Future<void> updateTransaction(int id, Map<String, dynamic> payload) async {
    final token = await _storage.read(key: 'token');
    final res = await http.put(
      Uri.parse('$baseUrl/transaction/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );
    print('STATUS: ${res.statusCode}');
    print('BODY: ${res.body}');

    if (res.statusCode != 200) {
      throw Exception('Gagal update transaksi');
    }
  }

  /// ================= DELETE =================
  Future<void> deleteTransaction(int id) async {
    final token = await _storage.read(key: 'token');
    final res = await http.delete(
      Uri.parse('$baseUrl/transactions/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw Exception('Gagal menghapus transaksi');
    }
    print('STATUS: ${res.statusCode}');
    print('BODY: ${res.body}');
  }

  Future<List<Transactionmodel>> fetchTodayTransactions() async {
    final token = await _storage.read(key: 'token');
    print('🔥 SERVICE DIPANGGIL');

    final res = await Apihelper.safeGet('/transaction/today', token);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      final List data = body['data'];
      print('Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
      return data.map((e) => Transactionmodel.fromJson(e)).toList();
    }

    throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
  }

  Future<Map<String, dynamic>> fetchWeeklyTransactions() async {
    final token = await _storage.read(key: 'token');
    final res = await Apihelper.safeGet('/transaction/weekly-summary', token);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body['result'];
    }

    throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
  }

  /// ================= BEST SELLING =================
  Future<List<Map<String, dynamic>>> fetchBestSelling() async {
    final token = await _storage.read(key: 'token');
    final res = await Apihelper.safeGet('/transaction/best-selling', token);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(body['data']);
    }

    throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
  }

  /// ================= MONTHLY SUMMARY =================
  Future<Map<String, dynamic>> fetchMonthlySummary() async {
    final token = await _storage.read(key: 'token');
    final res = await Apihelper.safeGet('/transaction/monthly-summary', token);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return body['result'];
    }

    throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
  }

  /// ================= MONTHLY CHART =================
  Future<List<Map<String, dynamic>>> fetchMonthlyChart() async {
    final token = await _storage.read(key: 'token');
    final res = await Apihelper.safeGet("/transaction/monthly-chart", token);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);
      return List<Map<String, dynamic>>.from(body['data']);
    }

    throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
  }
}
