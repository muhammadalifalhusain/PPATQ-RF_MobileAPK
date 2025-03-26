import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/santri_model.dart';
import '../models/kelas_model.dart';
import '../models/kesehatan_model.dart';
import '../models/berita_model.dart';
import '../models/agenda_model.dart';
import '../models/about_model.dart';
import '../models/galeri_model.dart';


class ApiService {
  static const String baseUrlLocal = "http://127.0.0.1:8000";
  static const String baseUrlHosting = "http://api.ppatq-rf.id/api";
  static const String fotoGaleriBaseUrl = "https://manajemen.ppatq-rf.id/assets/img/upload/foto_galeri";
  
  
  Future<List<Kelas>> fetchKelas() async {
    final response = await http.get(Uri.parse("$baseUrlLocal/kelas"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['data'];
      return jsonData.map((item) => Kelas.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data kelas");
    }
  }

  Future<Santri?> fetchSantri(String nama, String kelas) async {
    final response = await http.get(
      Uri.parse("$baseUrlLocal/santri?nama=$nama&kelas=$kelas"),
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

  Future<List<Kesehatan>> fetchKesehatanSantri() async {
    final response = await http.get(Uri.parse("$baseUrlLocal/kesehatan"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> list = data['data'];
      return list.map((json) => Kesehatan.fromJson(json)).toList();
    } else {
      throw Exception("Gagal mengambil data kesehatan");
    }
  }

  Future<List<Kesehatan>> searchKesehatanByNoInduk(String noInduk) async {
    final response = await http.get(Uri.parse("$baseUrlLocal/kesehatan?no_induk=$noInduk"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> rawData = data['data'];

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
    final response = await http.get(Uri.parse("$baseUrlLocal/berita"));

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body)['data'];
      return jsonData.map((item) => Berita.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data berita");
    }
  }

  // Ambil berita dari endpoint hosting
  Future<List<Berita>> fetchBeritaFromHosting() async {
    final response = await http.get(Uri.parse("$baseUrlHosting/berita"));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<dynamic> beritaList = jsonData['data']['data'];

      return beritaList.map((item) => Berita(
            judul: item['judul'],
            thumbnail: item['thumbnail'],
            // gambarDalam: item['gambar_dalam'],
            isiBerita: item['isi_berita'],
          )).toList();
    } else {
      throw Exception("Gagal mengambil data berita dari hosting");
    }
  }

  Future<About> fetchAbout() async {
    final response = await http.get(Uri.parse("$baseUrlHosting/about"));

    if (response.statusCode == 200) {
        return About.fromJson(response.body);
    } else {
        throw Exception("Gagal mengambil data About");
      }
    }

  Future<List<Agenda>> fetchAgenda({int perPage = 5, int page = 1}) async {
    final response = await http.get(
      Uri.parse("$baseUrlLocal/agenda?per_page=$perPage&page=$page"),
      headers: {
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      List<dynamic> agendaList = jsonData['data']['data'];
      return agendaList.map((item) => Agenda.fromJson(item)).toList();
    } else {
      throw Exception("Gagal mengambil data agenda");
    }
  }

    Future<List<Galeri>> fetchGaleri() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrlHosting/galeri"),
        headers: {"Accept": "application/json"},
      ).timeout(Duration(seconds: 10));

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);

        // Debugging Struktur JSON
        if (jsonData is Map<String, dynamic>) {
          print("JSON Structure: ${jsonData.keys}");
        }

        // Cek beberapa kemungkinan struktur response
        if (jsonData is Map<String, dynamic>) {
          if (jsonData.containsKey('data') && jsonData['data'] is Map<String, dynamic>) {
            if (jsonData['data'].containsKey('galeri')) {
              return _parseGaleri(jsonData['data']['galeri']);
            }
          } else if (jsonData.containsKey('galeri')) {
            return _parseGaleri(jsonData['galeri']);
          }
        }

        throw Exception("Struktur response tidak dikenali");
      } else {
        throw Exception("Request gagal dengan status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching galeri: $e");
      rethrow;
    }
  }

  List<Galeri> _parseGaleri(dynamic galeriData) {
    try {
      if (galeriData is List) {
        return galeriData
            .where((item) => item is Map<String, dynamic> && item['published'] == 1)
            .map((item) => Galeri.fromJson(item))
            .toList();
      } else {
        throw Exception("Format data galeri tidak valid");
      }
    } catch (e) {
      print("Error parsing galeri: $e");
      throw Exception("Gagal memparsing data galeri");
    }
  }
}


