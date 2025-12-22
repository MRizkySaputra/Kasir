import 'dart:io';
import 'package:flutter/material.dart';
import 'package:kasir/modules/menu/menuModel.dart';
import 'package:kasir/modules/menu/menuService.dart';

class ProductControllers extends ChangeNotifier {
  final ProductService _service = ProductService();

  // ================= STATE =================
  List<Product> _items = [];
  bool _loading = false;
  String? _error;

  // ================= GETTER =================
  List<Product> get items => _items;
  bool get loading => _loading;
  String? get error => _error;

  // ================= GET ALL =================
  Future<void> fetchMenu() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.fetchAll();
      _items = data.map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ================= CREATE =================
  Future<void> createMenu({
    required String name,
    required String description,
    required int price,
    required int stok,
    required String status,
    required String unit,
    File? image,
  }) async {
    try {
      _loading = true;
      notifyListeners();
      final result = await _service.create(
        name: name,
        description: description,
        price: price,
        stok: stok,
        status: status,
        unit: unit,
        image: image,
      );

      _items.add(Product.fromJson(result));
    } catch (e) {
      rethrow;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ================= UPDATE =================
  Future<void> updateMenu({
    required int id,
    required String name,
    required String description,
    required int price,
    required int stok,
    required String status,
    required String unit,
    File? image,
  }) async {
    try {
      final result = await _service.update(
        id,
        name: name,
        description: description,
        price: price,
        stok: stok,
        status: status,
        unit: unit,
        image: image,
      );

      final index = _items.indexWhere((e) => e.id == id);
      if (index != -1) {
        _items[index] = Product.fromJson(result);
        notifyListeners();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  // ================= DELETE =================
  Future<void> deleteMenu(int id) async {
    try {
      await _service.delete(id);
      _items.removeWhere((e) => e.id == id);
      notifyListeners();
    } catch (e) {
      throw e.toString();
    }
  }
}
