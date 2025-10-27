import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kelas_model.dart';

class KelasService {
  static Future<List<Kelas>> fetchKelas() async {
    final response = await http.get(Uri.parse('https://api.ppatq-rf.id/api/get/kelas'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> kelasList = jsonData['data'];
      return kelasList.map((e) => Kelas.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data kelas');
    }
  }
}
