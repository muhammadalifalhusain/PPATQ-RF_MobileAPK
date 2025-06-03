// services/pembayaran_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/pembayaran_model.dart';

class PembayaranService {
  static const String baseUrl = "https://api.ppatq-rf.id/api";

  Future<Map<String, dynamic>> getDataPembayaran(int noInduk, int periode, int tahun) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    final response = await http.post(
      Uri.parse("$baseUrl/index-pembayaran"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'no_induk': noInduk,
        'token': token,
        'periode': periode,
        'tahun': tahun,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load payment data');
    }
  }

  Future<bool> submitPembayaran(Pembayaran pembayaran, List<int> jenisPembayaran, List<double> nominalPembayaran) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token') ?? '';

    // Format authorization header sesuai dengan yang diharapkan backend
    final authHeader = "Bearer ${pembayaran.noInduk}-$token";

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/pembayaran"),
    );

    request.headers['Authorization'] = authHeader;

    // Tambahkan fields
    request.fields.addAll({
      'nama_santri': pembayaran.namaSantri,
      'jumlah': pembayaran.jumlah.toString(),
      'tanggal_bayar': pembayaran.tanggalBayar,
      'periode': pembayaran.periode.toString(),
      'tahun': pembayaran.tahun.toString(),
      'bank_pengirim': pembayaran.bankPengirim,
      'atas_nama': pembayaran.atasNama,
      'no_wa': pembayaran.noWa,
      'catatan': pembayaran.catatan ?? '',
    });

    // Tambahkan jenis pembayaran
    for (var i = 0; i < jenisPembayaran.length; i++) {
      request.fields['jenis_pembayaran[$i]'] = nominalPembayaran[i].toString();
      request.fields['id_jenis_pembayaran[$i]'] = jenisPembayaran[i].toString();
    }

    // Tambahkan file bukti pembayaran jika ada
    if (pembayaran.bukti != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'bukti',
        pembayaran.bukti!,
      ));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to submit payment');
    }
  }
}