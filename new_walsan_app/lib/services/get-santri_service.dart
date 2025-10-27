import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/get-santri_model.dart';

class SantriService {
  static const String baseUrl = 'https://api.ppatq-rf.id/api';

  static Future<SantriResponse> fetchAllSantri() async {
    final url = Uri.parse('$baseUrl/get/santri');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return SantriResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load santri data');
    }
  }
}