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

  // Ambil data kesehatan santri dari endpoint /kesehatan
  Future<List<Kesehatan>> fetchKesehatanSantri() async {
    final response = await http.get(Uri.parse("$baseUrl/kesehatan"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data'];

      // Mengelompokkan data berdasarkan no_induk
      Map<String, List<Pemeriksaan>> groupedData = {};

      for (var item in data) {
        String noInduk = item['no_induk'];
        Pemeriksaan pemeriksaan = Pemeriksaan.fromJson(item);

        if (!groupedData.containsKey(noInduk)) {
          groupedData[noInduk] = [];
        }
        groupedData[noInduk]!.add(pemeriksaan);
      }

      // Membuat daftar Kesehatan berdasarkan no_induk
      List<Kesehatan> kesehatanList = groupedData.entries.map((entry) {
        // Ambil nama santri dari data pertama yang memiliki no_induk yang sama
        String namaSantri = data.firstWhere(
          (e) => e['no_induk'] == entry.key,
          orElse: () => {'nama_santri': 'Tidak Diketahui'}, // Mencegah error jika data tidak ditemukan
        )['nama_santri'];

        return Kesehatan(
          noInduk: entry.key,
          namaSantri: namaSantri,
          pemeriksaan: entry.value,
        );
      }).toList();

      return kesehatanList;
    } else {
      throw Exception("Gagal mengambil data kesehatan");
    }
  }
}
