// providers/auth_provider.dart
import 'dart:ffi';

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

  Future<bool> login({
    required int noInduk,
    required String kode,
    required String tanggalLahir,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      final response = await _loginService.loginSiswa(
        noInduk: noInduk, 
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

  Future<void> _saveLoginData(LoginResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('no_induk', response.noInduk);
      await prefs.setString('kode', response.kode);
      await prefs.setString('nama', response.nama);
      await prefs.setString('photo', response.photo);
      await prefs.setString('kelas', response.kelas);
      await prefs.setBool('is_logged_in', true);
      
      await prefs.setString('login_data', json.encode(response.toJson()));
      
    } catch (e) {
      print('Error saving login data: $e');
    }
  }

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

  void updateUserData(LoginResponse newData) {
    _loginResponse = newData;
    _saveLoginData(newData);
    notifyListeners();
  }
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

  void clearError() {
    _clearError();
  }

  
}