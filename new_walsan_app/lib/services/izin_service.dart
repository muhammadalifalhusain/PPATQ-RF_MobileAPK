import 'dart:convert';
import '../models/izin_model.dart';
import '../utils/api_helper.dart';

class IzinSantriService {
  Future<IzinResponse> getDataIzinSantri() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response = await ApiHelper.get('/wali-santri/izin/$noInduk');

      if (response.statusCode == 200) {
        try {
          final decoded = jsonDecode(response.body);
          return IzinResponse.fromJson(decoded);
        } catch (e) {
          print('Gagal decode JSON: ${response.body}');
          throw Exception('Response bukan JSON valid: ${e.toString()}');
        }
      } else {
        print('RESPON ERROR: ${response.body}');
        throw Exception('Status ${response.statusCode}: ${response.reasonPhrase}');
      }

    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
