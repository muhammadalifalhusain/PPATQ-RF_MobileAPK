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
  DateTime? _expiresAt;

  LoginResponse? get loginResponse => _loginResponse;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get expiresAt => _expiresAt;
  
  final LoginService _loginService = LoginService();

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      _setLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      if (isLoggedIn) {
        final loginDataString = prefs.getString('login_data');
        final expiresAtString = prefs.getString('expiresAt');
        
        if (loginDataString != null && expiresAtString != null) {
          final loginDataJson = json.decode(loginDataString);
          _loginResponse = LoginResponse.fromJson(loginDataJson);
          _expiresAt = DateTime.parse(expiresAtString);
          
          if (DateTime.now().isBefore(_expiresAt!)) {
            _isLoggedIn = true;
          } else {
            await _clearSession();
          }
        } else {
          await _clearSession();
        }
      }
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setLoading(false);
      print('Error checking login status: $e');
      await _clearSession();
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

      await _saveSession(response);
      
      _loginResponse = response;
      _isLoggedIn = true;
      _expiresAt = DateTime.now().add(
        Duration(seconds: int.tryParse(response.expiresIn.toString()) ?? 0)
      );
      
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  Future<void> _saveSession(LoginResponse response) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expiresIn = int.tryParse(response.expiresIn.toString()) ?? 0;
      final expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

      await prefs.setInt('noInduk', response.noInduk);
      await prefs.setString('nama', response.nama);
      await prefs.setString('photo', response.photo);
      await prefs.setString('kelas', response.kelas);
      await prefs.setString('noVa', response.noVa);
      await prefs.setString('accessToken', response.accessToken);
      await prefs.setString('expiresIn', response.expiresIn.toString());
      await prefs.setString('expiresAt', expiresAt.toIso8601String());
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('login_data', json.encode(response.toJson()));

      print('Session valid until: ${expiresAt.toLocal()}');
    } catch (e) {
      print('Error saving session: $e');
      throw Exception('Failed to save session');
    }
  }

  Future<void> logout() async {
    try {
      final token = _loginResponse?.accessToken;
      if (token != null) {
        await _loginService.logout();
      }
      await _clearSession();
    } catch (e) {
      print('Error during logout: $e');
      await _clearSession();
      rethrow;
    }
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    _loginResponse = null;
    _isLoggedIn = false;
    _errorMessage = null;
    _expiresAt = null;
    
    notifyListeners();
  }

  void updateUserData(LoginResponse newData) {
    _loginResponse = newData;
    _saveSession(newData);
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

  // Menghitung sisa waktu validitas sesi dalam detik
  int get remainingSessionTime {
    if (_expiresAt == null) return 0;
    return _expiresAt!.difference(DateTime.now()).inSeconds;
  }

  // Memeriksa apakah sesi akan segera berakhir (dalam 5 menit)
  bool get isSessionAboutToExpire {
    return remainingSessionTime > 0 && remainingSessionTime < 300;
  }
}