import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:marketsapce_app/models/data_transfer_objects/product_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:marketsapce_app/models/user.dart';
import 'package:marketsapce_app/services/auth_service.dart';
import 'package:marketsapce_app/services/http_service.dart';

class UsersProvider with ChangeNotifier {
  User? _user;
  List<ProductInfo> _userProducts = [];

  final HttpService _httpService = HttpService();
  final AuthService _authService = AuthService();

  static const String _userKey = "user_data";

  User? get user {
    return _user;
  }

  List<ProductInfo> get userProducts {
    return [..._userProducts];
  }

  bool get isAuthenticated {
    return _user != null;
  }

  Future<void> _saveUserToLocalStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'avatar': user.avatar,
      'role': user.role.value,
      'isActive': user.isActive,
      'createdAt': user.createdAt.toString(),
    });

    await prefs.setString(_userKey, userJson);
  }

  Future<void> _loadUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      final userData = jsonDecode(userJson);

      final user = User(
        id: userData['id'],
        name: userData['name'],
        email: userData['email'],
        phone: userData['phone'],
        avatar: userData['avatar'],
        isActive: userData['isActive'],
        role: userData['role'],
        createdAt: userData['createdAt'],
      );

      _user = user;
    }
  }

  Future<void> initializerUser() async {
    await _loadUserFromLocalStorage();
  }

  Future<void> loadUserData() async {
    try {
      final response = await _httpService.get(endpoint: 'users/me');

      final user = User.fromJson(response.body);

      _user = user;

      await _saveUserToLocalStorage(user);

      notifyListeners();
    } catch (error) {
      print("Erro ao buscar usuário: $error");
    }
  }

  Future<void> fetchUserProducts(String userId) async {
    try {
      final response = await _httpService.get(
        endpoint: 'products/user/$userId',
      );

      final productsInfo =
          (response.body['products'] as List)
              .map((item) => ProductInfo.fromJson(item))
              .toList();

      _userProducts = productsInfo;
    } catch (error) {
      rethrow;
    } finally {
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userKey);
    await _authService.removeToken();

    _user = null;
    notifyListeners();
  }
}
