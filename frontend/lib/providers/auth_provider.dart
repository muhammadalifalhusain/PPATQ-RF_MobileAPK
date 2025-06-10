// providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/login_model.dart';
import '../services/login_service.dart';

class AuthProvider with ChangeNotifier {
  LoginResponse? _loginResponse;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  LoginResponse? get loginResponse => _loginResponse;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Auth Service
  final LoginService _loginService = LoginService();

  // Constructor - check if user is already logged in
  AuthProvider() {
    _checkLoginStatus();
  }

  // Check if user is already logged in when app starts
  Future<void> _checkLoginStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      if (isLoggedIn) {
        final loginDataString = prefs.getString('login_data');
        if (loginDataString != null) {
          final loginDataJson = json.decode(loginDataString);
          _loginResponse = LoginResponse.fromJson(loginDataJson);
          _isLoggedIn = true;
          notifyListeners();
        }
      }
    } catch (e) {
      print('Error checking login status: $e');
    }
  }

  // Login method
  Future<bool> login({
    required int noInduk,
    required String kode,
    required String tanggalLahir,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // Mengonversi noInduk ke String jika diperlukan
      final noIndukString = noInduk.toString();

      final response = await _loginService.loginSiswa(
        noInduk: noIndukString, 
        kode: kode,
        tanggalLahir: tanggalLahir,
      );

      // Save login data
      await _saveLoginData(response);
      
      _loginResponse = response;
      _isLoggedIn = true;
      
      _setLoading(false);
      notifyListeners();
      
      return true;
  } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      _setLoading(false);
      return false;
    }
  }

  // Save login data to SharedPreferences
  Future<void> _saveLoginData(LoginResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save individual fields for quick access
      await prefs.setString('no_induk', response.noInduk.toString());
      await prefs.setString('kode', response.kode);
      await prefs.setString('nama', response.nama);
      await prefs.setString('photo', response.photo);
      await prefs.setString('kelas', response.kelas);
      await prefs.setBool('is_logged_in', true);
      
      // Save complete login data as JSON string
      await prefs.setString('login_data', json.encode(response.toJson()));
      
    } catch (e) {
      print('Error saving login data: $e');
    }
  }

  // Logout method
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Clear all saved data
      await prefs.remove('no_induk');
      await prefs.remove('kode');
      await prefs.remove('nama');
      await prefs.remove('photo');
      await prefs.remove('kelas');
      await prefs.remove('login_data');
      await prefs.setBool('is_logged_in', false);
      
      // Clear state
      _loginResponse = null;
      _isLoggedIn = false;
      _errorMessage = null;
      
      notifyListeners();
    } catch (e) {
      print('Error during logout: $e');
    }
  }

  // Update user profile data (if needed)
  void updateUserData(LoginResponse newData) {
    _loginResponse = newData;
    _saveLoginData(newData);
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Clear error message
  void clearError() {
    _clearError();
  }

  // Get user saldo
  int get userSaldo => _loginResponse?.keuangan.saldo ?? 0;

  // Get user photo URL (you might need to add base URL)
  String get userPhotoUrl => _loginResponse?.photo ?? '';

  // Get user basic info
  String get userName => _loginResponse?.nama ?? 'Unknown';
  String get userClass => _loginResponse?.kelas ?? '';
  String get userNoInduk => _loginResponse?.noInduk.toString() ?? '';
}