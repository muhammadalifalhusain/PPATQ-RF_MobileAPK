import '../models/kesehatan_model.dart';
import '../utils/api_helper.dart';
import 'dart:convert';

class KesehatanService {
  Future<KesehatanResponse> getKesehatanData() async {
    try {
      final noInduk = await ApiHelper.getNoInduk(); 

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response = await ApiHelper.get('/wali-santri/kesehatan/$noInduk');

      if (response.statusCode == 200) {
        return KesehatanResponse.fromJson(json.decode(response.body));
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Gagal mengambil data kesehatan');
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}