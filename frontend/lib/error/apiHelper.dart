import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasir/error/apiException.dart';

class Apihelper {
  static String baseUrl =
      'https://kasir-git-main-agungs-projects-5080770e.vercel.app/api/v1';

  static http.Client _client = http.Client();
  static void resetClient() {
    _client.close();
    _client = http.Client();
  }

  static Future<http.Response> safeGet(String endpoint, String? token) async {
    if (token == null || token.isEmpty) {
      throw ApiException('Sesi login berakhir, silakan login ulang');
    }

    try {
      final res = await _client
          .get(
            Uri.parse('$baseUrl$endpoint'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(const Duration(seconds: 15));
      print('GET $endpoint');
      print('Status Code: ${res.statusCode}');
      print('Response Body: ${res.body}');
      return res;
    } on http.ClientException {
      resetClient();
      throw ApiException('Tidak dapat terhubung ke server');
    } on TimeoutException {
      resetClient();
      throw ApiException('Koneksi ke server terlalu lama');
    } catch (_) {
      resetClient();
      throw ApiException('Terjadi kesalahan jaringan');
    }
  }

  static String parseError(http.Response res) {
    try {
      final body = jsonDecode(res.body);

      if (body['message'] != null) return body['message'];

      if (body['errors'] != null && body['errors'] is List) {
        return body['errors'].map((e) => e['msg']).join('\n');
      }
    } catch (_) {}

    if (res.statusCode == 401) {
      return 'Akses ditolak, silakan login ulang';
    }

    return 'Terjadi kesalahan pada server';
  }
}
