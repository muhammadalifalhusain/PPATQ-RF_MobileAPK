import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/santri_model.dart';
import '../models/kelas_model.dart';

class ApiService {
  static const String baseUrl = "http://127.0.0.1:8000"; 

  // Ambil daftar kelas dari database
  Future<List<Kelas>> fetchKelas() async {
    final response = await http.get(Uri.parse("$baseUrl/kelas"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['data'];
      return jsonData.map((item) => Kelas.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data kelas");
    }
  }

  // Cari santri berdasarkan nama dan kelas
  Future<Santri?> fetchSantri(String nama, String kelas) async {
  final response = await http.get(
    Uri.parse("$baseUrl/santri?nama=$nama&kelas=$kelas"),
    headers: {
      "Accept": "application/json",
    },
  );

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return Santri.fromJson(jsonData['data']);
  } else {
    return null;
  }
}

}
