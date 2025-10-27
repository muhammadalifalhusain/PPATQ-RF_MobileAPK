import 'dart:convert';
import '../models/kerapian_model.dart';
import '../utils/api_helper.dart';

class KerapianService {
  Future<KerapianResponse> getDataKerapian() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response =
          await ApiHelper.get('/wali-santri/kerapian/$noInduk');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return KerapianResponse.fromJson(decoded);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ??
              'Gagal memuat data kerapian (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
