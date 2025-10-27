import 'dart:convert';
import '../models/keluhan_model.dart';
import '../utils/api_helper.dart';

class KeluhanService {
  Future<bool> submitKeluhan(Keluhan keluhan) async {
    try {
      final response = await ApiHelper.post('/keluhan', body: keluhan.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Gagal mengirim keluhan.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengirim keluhan: $e');
    }
  }

  Future<KeluhanResponse> fetchKeluhan() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();
      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan. Silakan login ulang.');
      }

      final response = await ApiHelper.get('/wali-santri/keluhan/$noInduk');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return KeluhanResponse.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(response.body);
        final errorMessage = errorData['message'] ?? 'Gagal memuat data keluhan.';
        throw Exception(errorMessage);
      }
    } catch (e, stackTrace) {
      print('❌ Exception di fetchKeluhan: $e');
      print('📌 StackTrace: $stackTrace');
      rethrow; 
    }
  }

}
