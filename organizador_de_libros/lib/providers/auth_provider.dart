import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  static const _tokenKey = 'auth_token';
  static const _userIdKey = 'user_id';
  static const _userNameKey = 'user_nombre';
  static const _userEmailKey = 'user_correo';

  final AuthService _authService;

  AuthProvider([AuthService? authService])
    : _authService = authService ?? AuthService();

  bool _isLoading = true;
  String? _token;
  User? _user;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null && _user != null;
  String? get token => _token;
  User? get user => _user;

  Future<void> bootstrap() async {
    _isLoading = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    final userId = prefs.getString(_userIdKey);
    final userName = prefs.getString(_userNameKey);
    final userEmail = prefs.getString(_userEmailKey);

    if (token != null &&
        userId != null &&
        userName != null &&
        userEmail != null) {
      _token = token;
      _user = User(id: userId, nombre: userName, correo: userEmail);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> register({
    required String nombre,
    required String correo,
    required String password,
  }) async {
    final result = await _authService.register(
      nombre: nombre,
      correo: correo,
      password: password,
    );
    await _saveSession(result.token, result.user);
  }

  Future<void> login({
    required String correo,
    required String password,
  }) async {
    final result = await _authService.login(correo: correo, password: password);
    await _saveSession(result.token, result.user);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await prefs.remove(_userNameKey);
    await prefs.remove(_userEmailKey);
    _token = null;
    _user = null;
    notifyListeners();
  }

  Future<void> _saveSession(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    await prefs.setString(_userIdKey, user.id);
    await prefs.setString(_userNameKey, user.nombre);
    await prefs.setString(_userEmailKey, user.correo);

    _token = token;
    _user = user;
    notifyListeners();
  }
}
