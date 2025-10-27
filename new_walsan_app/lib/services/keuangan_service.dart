import 'dart:convert';
import '../models/keuangan_model.dart';
import '../utils/api_helper.dart';

class KeuanganService {
  Future<UangResponse> getSakuMasuk() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();
      
      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response = await ApiHelper.get('/wali-santri/saku-masuk/$noInduk');

      if (response.statusCode == 200) {
        return UangResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Gagal memuat saku masuk (Status: ${response.statusCode})'
        );
      }
    } catch (e) {
      throw Exception('Error fetching saku masuk: ${e.toString()}');
    }
  }

  Future<UangResponse> getSakuKeluar() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();
      
      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response = await ApiHelper.get('/wali-santri/saku-keluar/$noInduk');

      if (response.statusCode == 200) {
        return UangResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 'Gagal memuat saku keluar (Status: ${response.statusCode})'
        );
      }
    } catch (e) {
      throw Exception('Error fetching saku keluar: ${e.toString()}');
    }
  }
}