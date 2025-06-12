class RiwayatBayarResponse {
  final int status;
  final String message;
  final PembayaranData data;

  RiwayatBayarResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory RiwayatBayarResponse.fromJson(Map<String, dynamic> json) {
    return RiwayatBayarResponse(
      status: json['status'],
      message: json['message'],
      data: PembayaranData.fromJson(json['data']),
    );
  }
}

class PembayaranData {
  final List<JenisPembayaran> jenisPembayaran;
  final List<TransaksiPembayaran> transaksi;

  PembayaranData({
    required this.jenisPembayaran,
    required this.transaksi,
  });

  factory PembayaranData.fromJson(Map<String, dynamic> json) {
    return PembayaranData(
      jenisPembayaran: List<JenisPembayaran>.from(
          json['jenisPembayaran'].map((x) => JenisPembayaran.fromJson(x))),
      transaksi: List<TransaksiPembayaran>.from(
          json['data'].map((x) => TransaksiPembayaran.fromJson(x))),
    );
  }
}

class JenisPembayaran {
  final int id;
  final String jenis;
  final int urutan;
  final int harga;

  JenisPembayaran({
    required this.id,
    required this.jenis,
    required this.urutan,
    required this.harga,
  });

  factory JenisPembayaran.fromJson(Map<String, dynamic> json) {
    return JenisPembayaran(
      id: json['id'],
      jenis: json['jenis'],
      urutan: json['urutan'],
      harga: json['harga'],
    );
  }
}

class TransaksiPembayaran {
  final String tanggalBayar;
  final String periode;
  final Map<String, String> jenisPembayaran;
  final String validasi;

  TransaksiPembayaran({
    required this.tanggalBayar,
    required this.periode,
    required this.jenisPembayaran,
    required this.validasi,
  });

  factory TransaksiPembayaran.fromJson(Map<String, dynamic> json) {
    return TransaksiPembayaran(
      tanggalBayar: json['tanggalBayar'],
      periode: json['periode'],
      jenisPembayaran: Map<String, String>.from(json['jenisPembayaran']),
      validasi: json['validasi'],
    );
  }

  String getFormattedPayment(int jenisId) {
    return jenisPembayaran[jenisId.toString()] ?? '0';
  }

  double getNumericPayment(int jenisId) {
    final value = jenisPembayaran[jenisId.toString()] ?? '0';
    return double.tryParse(value.replaceAll('.', '')) ?? 0;
  }
}