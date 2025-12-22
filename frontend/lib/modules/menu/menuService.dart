import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kasir/error/apiException.dart';
import 'package:kasir/error/apiHelper.dart';

class ProductService {
  final _storage = const FlutterSecureStorage();

  final String baseUrl =
      'https://kasir-git-main-agungs-projects-5080770e.vercel.app/api/v1/product';

  Future<List<dynamic>> fetchAll() async {
    final token = await _storage.read(key: 'token');

    final res = await Apihelper.safeGet("/product", token);

    final body = jsonDecode(res.body);

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
    }
    return body['result']['data'];
  }

  Future<Map<String, dynamic>> create({
    required String name,
    required String description,
    required int price,
    required int stok,
    required String status,
    required String unit,
    File? image,
  }) async {
    final token = await _storage.read(key: 'token');

    final request = http.MultipartRequest('POST', Uri.parse(baseUrl));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'name_product': name,
      'description': description,
      'price': price.toString(),
      'stok': stok.toString(),
      'status': status,
      'unit': unit,
    });

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('gambar', image.path),
      );
    }

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    final data = jsonDecode(resBody);

    print('Status code: ${response.statusCode}');
    print('Response body: $resBody');
    if (response.statusCode != 201) {
      throw data['message'];
    }

    return data['result'];
  }

  Future<Map<String, dynamic>> update(
    int id, {
    required String name,
    required String description,
    required int price,
    required int stok,
    required String status,
    required String unit,
    File? image,
  }) async {
    final token = await _storage.read(key: 'token');

    final request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/$id'));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields.addAll({
      'name_product': name,
      'description': description,
      'price': price.toString(),
      'stok': stok.toString(),
      'status': status,
      'unit': unit,
    });

    if (image != null) {
      request.files.add(
        await http.MultipartFile.fromPath('gambar', image.path),
      );
    }

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    final data = jsonDecode(resBody);

    if (response.statusCode != 200) {
      debugPrint('Error status code: ${response.statusCode}');
      debugPrint('Error response body: $resBody');
      throw Exception(data['message'] ?? 'Unknown error');
    } else {
      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: $resBody');
    }

    return data['result'];
  }

  Future<void> delete(int id) async {
    final token = await _storage.read(key: 'token');

    final res = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
    }
  }
}
