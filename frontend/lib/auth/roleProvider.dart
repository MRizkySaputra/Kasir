import 'package:flutter/material.dart';
import 'role.dart';

class RoleProvider extends ChangeNotifier {
  UserRole _role = UserRole.unknown;

  UserRole get role => _role;

  void setRoleFromString(String? roleStr) {
    final newRole = _mapStringToUserRole(roleStr);
    if (newRole != _role) {
      _role = newRole;
      notifyListeners();
    }
  }

  UserRole _mapStringToUserRole(String? roleStr) {
    switch (roleStr?.toLowerCase()) {
      case 'admin':
        return UserRole.admin;
      case 'kasir':
        return UserRole.kasir;
      default:
        return UserRole.unknown;
    }
  }
}
