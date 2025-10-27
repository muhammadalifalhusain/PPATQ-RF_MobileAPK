import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/get_bank_model.dart'; 
class BankService {
  final String _baseUrl = "https://api.ppatq-rf.id/api/get/bank";

  Future<BankResponse> getBanks() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        return BankResponse.fromJson(json.decode(response.body));
      } else {
        throw Exception(
            'Failed to load banks. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load banks: $e');
    }
  }
}