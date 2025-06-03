import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BaseApi {
  final http.Client client;

  BaseApi({http.Client? client}) : client = client ?? http.Client();

  String get baseUrlLocal => dotenv.env['BASE_URL_LOCAL'] ?? 'http://127.0.0.1:8000';
  String get baseUrlHosting => dotenv.env['BASE_URL_HOSTING'] ?? 'https://api.ppatq-rf.id/api';
  String get fotoGaleriBaseUrl => dotenv.env['FOTO_GALERI_BASE_URL'] ?? '';

  Uri buildUri(String path, {bool useHosting = true, Map<String, dynamic>? queryParameters}) {
    final baseUrl = useHosting ? baseUrlHosting : baseUrlLocal;
    return Uri.parse(baseUrl + path).replace(queryParameters: queryParameters);
  }
}
