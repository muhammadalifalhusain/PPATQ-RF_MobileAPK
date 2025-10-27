import 'dart:convert';
import '../models/pelanggaran_model.dart';
import '../utils/api_helper.dart';

class PelanggaranService {
  Future<PelanggaranResponse> getDataPelanggaran() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response =
          await ApiHelper.get('/wali-santri/pelanggaran/$noInduk');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return PelanggaranResponse.fromJson(decoded);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ??
              'Gagal memuat data pelanggaran (Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
