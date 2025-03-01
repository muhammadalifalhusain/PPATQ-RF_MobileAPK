import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/santri_model.dart';
import '../models/kelas_model.dart';
import '../models/kesehatan_model.dart';

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

  // Ambil semua data kesehatan
  Future<List<Kesehatan>> fetchKesehatanSantri() async {
    final response = await http.get(Uri.parse("$baseUrl/kesehatan")); // Perbaikan endpoint

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> list = data['data'];
      return list.map((json) => Kesehatan.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data kesehatan");
    }
  }

  // Ambil data kesehatan berdasarkan No Induk
 Future<List<Kesehatan>> searchKesehatanByNoInduk(String noInduk) async {
  final response = await http.get(Uri.parse("$baseUrl/kesehatan?no_induk=$noInduk"));

  print("Response dari API: ${response.body}"); // Debug respons API

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);

    // Debug format data
    print("Isi data['data']: ${data['data']}");

    if (data.containsKey('data') && data['data'] is List) {
      List<dynamic> list = data['data'];
      return list.map((json) => Kesehatan.fromJson(json)).toList();
    } else {
      return []; // Jika tidak ada data, kembalikan list kosong
    }
  } else {
    throw Exception("Gagal mencari data kesehatan");
  }
}

}
