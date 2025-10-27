import 'dart:convert';
import '../utils/api_helper.dart';
import '../models/agenda_model.dart';

class AgendaService {
  Future<AgendaResponse> fetchAgenda({int page = 1}) async {
    try {
      final response = await ApiHelper.get('/agenda?page=$page');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return AgendaResponse.fromJson(jsonData['data']);
      } else {
        final errorData = json.decode(response.body);
        final errorMessage = errorData['message'] ?? 'Gagal mengambil data agenda.';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil data agenda: $e');
    }
  }
}
