import 'dart:convert';
import '../models/berita_model.dart';
import '../utils/api_helper.dart';

class BeritaService {
  Future<BeritaResponse> fetchBerita({int page = 1}) async {
    try {
      final response = await ApiHelper.get('/berita?page=$page');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return BeritaResponse.fromJson(jsonData);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengambil data berita.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data berita: $e');
    }
  }
}
