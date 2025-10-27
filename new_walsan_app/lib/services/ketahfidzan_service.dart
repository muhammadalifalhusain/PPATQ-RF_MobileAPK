import 'dart:convert';
import '../models/ketahfidzan_model.dart';
import '../utils/api_helper.dart';

class KetahfidzanService {
  Future<KetahfidzanResponse> fetchKetahfidzan() async {
    try {
      final noInduk = await ApiHelper.getNoInduk(); 

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response = await ApiHelper.get('/wali-santri/ketahfidzan/$noInduk');

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        return KetahfidzanResponse.fromJson(jsonResponse);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 
          'Gagal mengambil data ketahfidzan (Status: ${response.statusCode})'
        );
      }
    } catch (e) {
      throw Exception('Error fetching ketahfidzan: ${e.toString()}');
    }
  }
}