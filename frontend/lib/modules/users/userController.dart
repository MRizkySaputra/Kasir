import 'package:flutter/material.dart';
import 'package:kasir/auth/roleProvider.dart';
import 'package:kasir/modules/users/userModel.dart';
import 'package:kasir/modules/users/userService.dart';
import 'package:provider/provider.dart';

class UserController extends ChangeNotifier {
  UserModel? _currentUser;
  UserModel? get currentUser => _currentUser;
  String? get role => _currentUser?.role;

  /// 👥 LIST USER (ADMIN)
  List<UserModel> users = [];

  bool isLoading = false;
  String? errorMessage;

  /// 🔹 SET USER DARI LOGIN
  void setUser(UserModel user, BuildContext context) {
    _currentUser = user;
    Provider.of<RoleProvider>(
      context,
      listen: false,
    ).setRoleFromString(user.role);
    notifyListeners();
  }

  /// 🔹 CLEAR SAAT LOGOUT
  void clearUser() {
    _currentUser = null;
    users.clear();
    notifyListeners();
  }

  /// GET USERS
  Future<void> fetchUsers() async {
    try {
      isLoading = true;
      notifyListeners();
      errorMessage = null;
      users = await UserService.getUsers();

      notifyListeners();
    } catch (error) {
      debugPrint('Error fetchUsers: $error');
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      notifyListeners();
      errorMessage = null;

      _currentUser = await UserService.getProfile();

      notifyListeners();
    } catch (error) {
      debugPrint('Error fetchUserById: $error');
      errorMessage = error.toString();
      _currentUser = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// CREATE USER
  Future<void> addUser(UserModel user) async {
    try {
      isLoading = true;
      notifyListeners();
      await UserService.createUser(user);
      await fetchUsers();
    } catch (error) {
      debugPrint('Error addUser: $error');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// UPDATE USER
  Future<void> editUser(int id, UserModel user) async {
    try {
      isLoading = true;
      notifyListeners();
      await UserService.updateUser(id, user);
      await fetchUsers();
    } catch (error) {
      debugPrint('Error editUser: $error');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// DELETE USER
  Future<void> removeUser(int id) async {
    try {
      isLoading = true;
      notifyListeners();

      await UserService.deleteUser(id);

      await fetchUsers();
    } catch (error) {
      debugPrint('Error removeUser: $error');
      rethrow;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
