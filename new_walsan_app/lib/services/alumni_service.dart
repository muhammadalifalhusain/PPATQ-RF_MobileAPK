import 'dart:convert';
import '../models/alumni_model.dart';
import '../utils/api_helper.dart';

class AlumniService {
  static const String _endpoint = '/alumni';

  static Future<AlumniResponse?> fetchAlumni({String? search}) async {
    try {
      String url = _endpoint;
      if (search != null && search.isNotEmpty) {
        url += '/$search';
      }

      final response = await ApiHelper.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is Map<String, dynamic>) {
          return AlumniResponse.fromJson(decoded);
        } else {
          print('[ERROR] Unexpected response type: ${decoded.runtimeType}');
        }
      } else {
        print('[ERROR] Request failed: ${response.statusCode}');
      }
    } catch (e) {
    }

    return null;
  }
}
