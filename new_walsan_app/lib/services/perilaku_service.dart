import 'dart:convert';
import '../models/perilaku_model.dart';
import '../utils/api_helper.dart';

class PerilakuService {
  Future<PerilakuResponse> fetchPerilaku() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response = await ApiHelper.get('/wali-santri/perilaku/$noInduk');

      if (response.statusCode == 200) {
        return PerilakuResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 
          'Gagal mengambil data perilaku (Status: ${response.statusCode})'
        );
      }
    } catch (e) {
      throw Exception('Error fetching data perilaku: ${e.toString()}');
    }
  }
}