import '../models/riwayat_bayar_model.dart';
import '../utils/api_helper.dart';
import 'dart:convert';

class RiwayatBayarService {
  Future<RiwayatBayarResponse> getRiwayatPembayaran() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response = await ApiHelper.get('/wali-santri/riwayat-bayar/$noInduk');

      if (response.statusCode == 200) {
        return RiwayatBayarResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 
          'Gagal memuat riwayat pembayaran (Status: ${response.statusCode})'
        );
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}