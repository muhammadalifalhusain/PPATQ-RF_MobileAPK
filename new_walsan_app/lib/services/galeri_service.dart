import 'dart:convert';
import '../models/galeri_model.dart';
import '../utils/api_helper.dart';

class GaleriService {
  static const String _endpoint = '/galeri';

  static Future<List<GaleriItem>> fetchGaleri() async {
    try {
      final response = await ApiHelper.get(_endpoint);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final galeriData = GaleriResponse.fromJson(jsonData);
        return galeriData.data.galeri;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<List<GaleriItem>> fetchFasilitas() async {
    try {
      final response = await ApiHelper.get(_endpoint);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final galeriData = GaleriResponse.fromJson(jsonData);
        return galeriData.data.fasilitas;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}
