import 'dart:convert';
import '../models/kelengkapan_model.dart';
import '../utils/api_helper.dart';

class KelengkapanService {
  Future<KelengkapanResponse> fetchKelengkapan() async {
    try {
      final noInduk = await ApiHelper.getNoInduk();

      if (noInduk == null) {
        throw Exception('No Induk tidak ditemukan');
      }

      final response = await ApiHelper.get('/wali-santri/kelengkapan/$noInduk');

      if (response.statusCode == 200) {
        return KelengkapanResponse.fromJson(jsonDecode(response.body));
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(
          errorData['message'] ?? 
          'Gagal mengambil data kelengkapan (Status: ${response.statusCode})'
        );
      }
    } catch (e) {
      throw Exception('Gagal memuat data kelengkapan: ${e.toString()}');
    }
  }
  KelengkapanResponse? _cachedData;
  DateTime? _lastFetchTime;

  Future<KelengkapanResponse> fetchKelengkapanWithCache({bool forceRefresh = false}) async {
    if (!forceRefresh && 
        _cachedData != null && 
        _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < Duration(minutes: 30)) {
      return _cachedData!;
    }

    try {
      final data = await fetchKelengkapan();
      _cachedData = data;
      _lastFetchTime = DateTime.now();
      return data;
    } catch (e) {
      if (_cachedData != null) {
        return _cachedData!;
      }
      rethrow;
    }
  }
}