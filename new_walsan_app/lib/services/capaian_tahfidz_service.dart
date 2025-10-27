import 'dart:convert';
import '../utils/api_helper.dart';
import '../models/capaian_tahfidz_model.dart';

class CapaianTahfidzService {
  static Future<CapaianTahfidzResponse?> fetchCapaianTahfidz() async {
    try {
      final res = await ApiHelper.get('/capaian-tahfidz');

      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(res.body);

        if (jsonData.containsKey('data')) {
          return CapaianTahfidzResponse.fromJson(jsonData);
        } else {
          print('Respons tidak mengandung key "data": $jsonData');
        }
      } else {
        print('Gagal mendapatkan data capaian tahfidz: ${res.statusCode}');
        print('Response body: ${res.body}');
      }
    } catch (e) {
      print('Error saat mengambil data capaian tahfidz: $e');
    }
    return null;
  }
}
