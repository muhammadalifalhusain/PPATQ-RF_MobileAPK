import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pembayaran_model.dart';
import 'dart:developer' as developer;

class PembayaranService {
  static const String baseUrl = "https://api.ppatq-rf.id/api";
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
  Future<List<JenisPembayaran>> getJenisPembayaran() async {
    try {
      final url = "$baseUrl/jenis_pembayaran";
      
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Request timeout - Server tidak merespons dalam 30 detik');
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

          if (!jsonResponse.containsKey('data')) {
            throw Exception('Response tidak memiliki key "data"');
          }

          if (jsonResponse['data'] is! List) {
            throw Exception('Field "data" bukan berupa List');
          }

          final List<JenisPembayaran> jenisPembayaran =
              JenisPembayaranModel.fromJson(jsonResponse).data;

          developer.log(
              '🎉 Success: Loaded ${jenisPembayaran.length} jenis pembayaran',
              name: 'PembayaranService');

          return jenisPembayaran;
        } catch (e) {
          developer.log('❌ JSON Parsing Error: $e', name: 'PembayaranService');
          throw Exception('Gagal parsing JSON: $e');
        }
      } else {
        String errorMessage = 'HTTP ${response.statusCode}';
        
        switch (response.statusCode) {
          case 404:
            errorMessage = 'Endpoint tidak ditemukan (404)';
            break;
          case 500:
            errorMessage = 'Server error (500)';
            break;
          case 401:
            errorMessage = 'Unauthorized (401)';
            break;
          case 403:
            errorMessage = 'Forbidden (403)';
            break;
          default:
            errorMessage = 'HTTP Error ${response.statusCode}: ${response.body}';
        }
        
        developer.log('❌ HTTP Error: $errorMessage', name: 'PembayaranService');
        throw Exception(errorMessage);
      }
    } catch (e) {
      developer.log('💥 Exception caught: $e', name: 'PembayaranService');
      developer.log('🔍 Exception type: ${e.runtimeType}', name: 'PembayaranService');
      
      if (e.toString().contains('SocketException')) {
        throw Exception('Tidak dapat terhubung ke server. Periksa koneksi internet dan URL API');
      } else if (e.toString().contains('TimeoutException')) {
        throw Exception('Request timeout - Server tidak merespons');
      } else if (e.toString().contains('FormatException')) {
        throw Exception('Format response tidak valid');
      } else {
        throw Exception('Failed to load jenis pembayaran: $e');
      }
    }
  }
  Future<void> postPembayaran(Pembayaran pembayaran, File? buktiBayar) async {
    try {
      developer.log('🚀 Mengirim data pembayaran...', name: 'PembayaranService');

      final token = await _getToken();
      if (token == null) {
        throw Exception('Token tidak tersedia, silakan login kembali');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/wali-santri/lapor-bayar"),
      );

      // Add authorization header
      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(pembayaran.toFormFields());
      if (buktiBayar != null) {
        request.files.add(
          await http.MultipartFile.fromPath('bukti', buktiBayar.path),
        );
      }

      developer.log('📤 Fields yang dikirim:', name: 'PembayaranService');
      request.fields.forEach((key, value) {
        developer.log('  $key: $value', name: 'PembayaranService');
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = jsonDecode(responseBody);
        if (jsonResponse['status'] == 200 || jsonResponse['status'] == 201) {
          return;
        }
      }
      
      if (response.statusCode == 409) {
        final jsonResponse = jsonDecode(responseBody);
        throw Exception(jsonResponse['message'] ?? 'Data sudah ada');
      }

      throw Exception('Gagal mengirim pembayaran (${response.statusCode}): $responseBody');

    } catch (e) {
      developer.log('💥 Exception: $e', name: 'PembayaranService');
      throw Exception('Terjadi kesalahan saat mengirim pembayaran: ${e.toString()}');
    }
  }
}