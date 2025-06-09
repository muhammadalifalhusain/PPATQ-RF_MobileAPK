import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/tahfidz-data.dart';

class TahfidzService {
  static const String baseUrl = 'https://api.ppatq-rf.id/api';

  static Future<TahfidzResponse> fetchTahfidzData(int idUser) async {
    final url = Uri.parse('$baseUrl/ustad-tahfidz/santri/$idUser');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return TahfidzResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load tahfidz data');
    }
  }
}