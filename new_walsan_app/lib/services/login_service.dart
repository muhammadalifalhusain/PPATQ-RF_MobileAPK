import 'dart:convert';
import '../models/login_model.dart';
import '../utils/api_helper.dart';

class LoginService {
  Future<LoginResponse> loginSiswa({
    required int noInduk,
    required String kode,
    required String tanggalLahir,
  }) async {
    try {
      final response = await ApiHelper.post(
        '/wali-santri/login',
        body: {
          "noInduk": noInduk,
          "kode": kode,
          "tanggalLahir": tanggalLahir,
        },
      );

      final jsonData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (jsonData['data'] != null) {
          try {
            return LoginResponse.fromJson(jsonData['data']);
          } catch (_) {
            throw 'Terjadi kesalahan saat memproses data login.';
          }
        } else {
          throw jsonData['message'] ?? 'Data tidak ditemukan dalam respons.';
        }
      } else {
        // Ambil pesan error dari key `errors` atau `message`
        if (jsonData['errors'] != null) {
          final firstError = jsonData['errors'].values.first;
          if (firstError is List && firstError.isNotEmpty) {
            throw firstError[0];
          }
        }

        throw jsonData['message'] ?? 'Login gagal. Status: ${response.statusCode}';
      }
    } catch (e) {
      
      rethrow;
    }
  }

  Future<LogoutResponse> logout() async {
    try {
      final response = await ApiHelper.post('/wali-santri/logout');

      if (response.statusCode == 200) {
        return LogoutResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw errorData['message'] ?? 'Logout gagal';
      }
    } catch (e) {
      rethrow;
    }
  }
}
