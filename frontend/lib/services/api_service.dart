import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/santri_model.dart';
import '../models/kelas_model.dart';
import '../models/kesehatan_model.dart';
import '../models/berita_model.dart';

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

Future<List<Kesehatan>> searchKesehatanByNoInduk(String noInduk) async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/kesehatan?no_induk=$noInduk'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> rawData = data['data'];

      // Mengelompokkan data berdasarkan no_induk
      Map<String, Kesehatan> groupedData = {};

      for (var item in rawData) {
        String noInduk = item['no_induk'];
        String namaSantri = item['nama_santri'];

        if (!groupedData.containsKey(noInduk)) {
          groupedData[noInduk] = Kesehatan(
            noInduk: noInduk,
            namaSantri: namaSantri,
            pemeriksaan: [],
          );
        }

        // Menambahkan data pemeriksaan ke dalam list
        groupedData[noInduk]!.pemeriksaan.add({
          "tanggal_pemeriksaan": item['tanggal_pemeriksaan'],
          "tinggi_badan": item['tinggi_badan'],
          "berat_badan": item['berat_badan'],
          "lingkar_pinggul": item['lingkar_pinggul'],
          "lingkar_dada": item['lingkar_dada'],
          "kondisi_gigi": item['kondisi_gigi'],
        });
      }

      return groupedData.values.toList();
    } else {
      throw Exception('Gagal mengambil data kesehatan');
    }
  }

  Future<List<Berita>> fetchBerita() async {
    final response = await http.get(Uri.parse("$baseUrl/berita"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['data'];
      return jsonData.map((item) => Berita.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data berita");
    }
  }
}
