class KetertibanResponse {
  final int status;
  final String message;
  final List<Ketertiban> data;

  KetertibanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KetertibanResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List<dynamic>? ?? [];

    // Jika semua elemen berisi tanda "-", kembalikan list kosong
    final isDummyData = rawData.isNotEmpty &&
        rawData.every((item) =>
            (item is Map<String, dynamic>) &&
            item.values.every((v) => v.toString().trim() == '-'));

    return KetertibanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: isDummyData
          ? []
          : rawData.map((item) => Ketertiban.fromJson(item ?? {})).toList(),
    );
  }
}

class Ketertiban {
  final String tanggal;
  final String nama;
  final int buangSampah;
  final int menataPeralatan;
  final int tidakBerseragam;
  final String namaPengisi;

  Ketertiban({
    required this.tanggal,
    required this.nama,
    required this.buangSampah,
    required this.menataPeralatan,
    required this.tidakBerseragam,
    required this.namaPengisi,
  });

  factory Ketertiban.fromJson(Map<String, dynamic> json) {
    return Ketertiban(
      tanggal: _parseString(json['tanggal']),
      nama: _parseString(json['nama']),
      buangSampah: _parseInt(json['buangSampah']),
      menataPeralatan: _parseInt(json['menataPeralatan']),
      tidakBerseragam: _parseInt(json['tidakBerseragam']),
      namaPengisi: _parseString(json['namaPengisi']),
    );
  }

  static String _parseString(dynamic value) {
    if (value == null || value.toString().trim() == '-') {
      return '';
    }
    return value.toString();
  }

  static int _parseInt(dynamic value) {
    if (value == null || value.toString().trim() == '-') {
      return 0;
    }
    return int.tryParse(value.toString()) ?? 0;
  }
}
