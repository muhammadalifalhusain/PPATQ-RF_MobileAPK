import 'dart:convert';
import '../models/dakwah_model.dart';
import '../utils/api_helper.dart';

class DakwahService {
  static const String _endpoint = '/dakwah';

  static Future<List<DakwahItem>> fetchDakwah({int page = 1}) async {
    try {
      final response = await ApiHelper.get('$_endpoint?page=$page');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final dakwahResponse = DakwahResponse.fromJson(jsonData);
        return dakwahResponse.data.data;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
