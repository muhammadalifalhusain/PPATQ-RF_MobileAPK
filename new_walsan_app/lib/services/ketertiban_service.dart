import 'dart:convert';
import '../models/ketertiban_model.dart';
import '../utils/api_helper.dart';

class KetertibanService {
  Future<KetertibanResponse> getDataKetertiban() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response =
          await ApiHelper.get('/wali-santri/pelanggaran-ketertiban/$noInduk');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return KetertibanResponse.fromJson(decoded);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ??
              'Gagal memuat data ketertiban (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
