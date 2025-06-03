import 'dart:convert';
import 'package:http/http.dart' as http;
import 'base_api.dart';
import '../models/login_model.dart';

class LoginService extends BaseApi {
  LoginService({http.Client? client}) : super(client: client);

  Future<LoginResponse> loginSiswa({
    required int noInduk,
    required String kode,
    required String password,
  }) async {
    final response = await client.post(
      buildUri("/siswa/login", useHosting: true),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({
        "no_induk": noInduk,
        "kode": kode,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      final jsonData = jsonDecode(response.body);
      return LoginResponse.fromJson(jsonData['data']);
    } else {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Login failed');
    }
  }
}
