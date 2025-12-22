import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kasir/error/apiException.dart';
import 'package:kasir/error/apiHelper.dart';
import 'package:kasir/modules/users/userModel.dart';

class UserService {
  static final _storage = const FlutterSecureStorage();
  static const String baseUrl =
      'https://kasir-git-main-agungs-projects-5080770e.vercel.app/api/v1/users';

  /// GET USERS
  static Future<List<UserModel>> getUsers() async {
    final token = await _storage.read(key: 'token');
    final res = await Apihelper.safeGet("/users", token);

    if (res.statusCode == 200) {
      final body = jsonDecode(res.body);

      final List usersJson = body['data']['user'];

      return usersJson.map((json) => UserModel.fromJson(json)).toList();
    } else {
      debugPrint('STATUS CODE: ${res.statusCode}');
      debugPrint('RESPONSE BODY: ${res.body}');

      throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
    }
  }

  static Future<UserModel> getProfile() async {
    final token = await _storage.read(key: 'token');
    final res = await Apihelper.safeGet('/auth/profile', token);

    if (res.statusCode == 200) {
      final decoded = jsonDecode(res.body);
      final usersJson = decoded['data'];

      return UserModel.fromJson(usersJson);
    } else {
      debugPrint('STATUS CODE: ${res.statusCode}');
      debugPrint('RESPONSE BODY: ${res.body}');
      throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
    }
  }

  /// CREATE USER
  static Future<void> createUser(UserModel user) async {
    final token = await _storage.read(key: 'token');
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    debugPrint('STATUS CODE: ${res.statusCode}');
    debugPrint('RESPONSE BODY: ${res.body}');

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
    }
  }

  /// UPDATE USER
  static Future<void> updateUser(int id, UserModel user) async {
    final token = await _storage.read(key: 'token');
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(user.toJson()),
    );

    if (res.statusCode != 200) {
      throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
    }
  }

  /// DELETE USER
  static Future<void> deleteUser(int id) async {
    final token = await _storage.read(key: 'token');
    final res = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode != 200) {
      throw ApiException(Apihelper.parseError(res), statusCode: res.statusCode);
    }
  }
}
