import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/kategori_keluhan_model.dart';

class KategoriKeluhanService {
  static const String _baseUrl = 'https://api.ppatq-rf.id/api/get/kategori-keluhan';

  static Future<List<KategoriKeluhan>> fetchKategoriKeluhan() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List data = jsonData['data'];
      return data.map((item) => KategoriKeluhan.fromJson(item)).toList();
    } else {
      throw Exception('Gagal memuat kategori keluhan');
    }
  }
}
