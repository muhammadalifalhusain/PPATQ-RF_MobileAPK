import 'dart:convert';
import 'package:frontend/models/tutorial_pembayaran_model.dart';
import 'package:http/http.dart' as http;

class InfoPembayaranService {
  static const String _baseUrl = 'https://api.ppatq-rf.id/api';

  static Future<List<TutorialPembayaran>> fetchTutorialPembayaran() async {
    final url = Uri.parse('$_baseUrl/tutorial-pembayaran');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final result = TutorialPembayaranResponse.fromJson(jsonData);
      return result.data;
    } else {
      throw Exception('Gagal memuat informasi pembayaran: ${response.statusCode}');
    }
  }
}
