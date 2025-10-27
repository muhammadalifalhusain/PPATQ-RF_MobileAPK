import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/santri_model.dart';
import '../models/about_model.dart';
import '../models/galeri_model.dart';


class ApiService {
  static const String baseUrlLocal = "http://127.0.0.1:8000";
  static const String baseUrlHosting = "https://api.ppatq-rf.id/api";
  static const String fotoGaleriBaseUrl = "https://manajemen.ppatq-rf.id/assets/img/upload/berita/thumbnail/";
  
  
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

  Future<About> fetchAbout() async {
    final response = await http.get(Uri.parse("$baseUrlHosting/about"));

    if (response.statusCode == 200) {
        return About.fromJson(response.body);
    } else {
        throw Exception("Gagal mengambil data About");
      }
    }
    

  

}


