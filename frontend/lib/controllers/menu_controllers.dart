// lib/controllers/menu_controller.dart
import 'package:flutter/material.dart';

/// Model sederhana untuk menu item
class MenuItem {
  String name;
  int price;
  String? image; // optional, bisa diisi url atau asset

  MenuItem({required this.name, required this.price, this.image});
}

/// Controller yang menampung daftar menu dan operasi CRUD (local)
class MenuControllers extends ChangeNotifier {
  final List<MenuItem> _items = [
    MenuItem(name: "Nasi Goreng", price: 15000),
    MenuItem(name: "Ayam Geprek", price: 18000),
    MenuItem(name: "Es Teh", price: 6000),
  ];

  List<MenuItem> get items => List.unmodifiable(_items);

  // Add new menu
  void addMenu(String name, int price, {String? image}) {
    _items.add(MenuItem(name: name, price: price, image: image));
    notifyListeners();
  }

  // Edit existing menu by index
  void editMenu(int index, String name, int price, {String? image}) {
    if (index < 0 || index >= _items.length) return;
    _items[index].name = name;
    _items[index].price = price;
    _items[index].image = image;
    notifyListeners();
  }

  // Delete
  void deleteMenu(int index) {
    if (index < 0 || index >= _items.length) return;
    _items.removeAt(index);
    notifyListeners();
  }

  // Search helper (by name)
  List<MenuItem> search(String query) {
    if (query.trim().isEmpty) return items;
    final q = query.toLowerCase();
    return _items.where((e) => e.name.toLowerCase().contains(q)).toList();
  }
}