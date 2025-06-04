import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pegawai_model.dart';

class PegawaiService {
  static const String _baseUrl = 'https://api.ppatq-rf.id/api';

  Future<List<Pegawai>> fetchUstadz() => _fetchPegawai('/get-ustadz');

  Future<List<Pegawai>> fetchMurroby() => _fetchPegawai('/get-murroby');

  Future<List<Pegawai>> fetchStaff() => _fetchPegawai('/get-staff');

  Future<List<Pegawai>> _fetchPegawai(String endpoint) async {
    final response = await http.get(Uri.parse('$_baseUrl$endpoint'));

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> data = decoded['data'] ?? [];

      return data.map((json) => Pegawai.fromJson(json)).toList();
    } else {
      throw Exception('Gagal memuat data dari endpoint: $endpoint');
    }
  }
}
