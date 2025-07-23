class PelanggaranResponse {
  final int status;
  final String message;
  final List<PelanggaranData> data;

  PelanggaranResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PelanggaranResponse.fromJson(Map<String, dynamic> json) {
    return PelanggaranResponse(
      status: json['status'] ?? 0,
      message: (json['message'] ?? '').toString(),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => PelanggaranData.fromJson(e))
          .toList(),
    );
  }
}

class PelanggaranData {
  final int id;
  final String nama;
  final String tanggal;
  final String jenisPelanggaran;
  final String kategori;
  final String hukuman;
  final String bukti;
  final String namaPengisi;

  PelanggaranData({
    required this.id,
    required this.nama,
    required this.tanggal,
    required this.jenisPelanggaran,
    required this.kategori,
    required this.hukuman,
    required this.bukti,
    required this.namaPengisi,
  });

  factory PelanggaranData.fromJson(Map<String, dynamic> json) {
    String _sanitize(dynamic val) {
      final str = val?.toString().trim();
      return (str == null || str.isEmpty || str == 'null') ? '-' : str;
    }

    return PelanggaranData(
      id: json['id'] ?? 0,
      nama: _sanitize(json['nama']),
      tanggal: _sanitize(json['tanggal']),
      jenisPelanggaran: _sanitize(json['jenisPelanggaran']),
      kategori: _sanitize(json['kategori']),
      hukuman: _sanitize(json['hukuman']),
      bukti: _sanitize(json['bukti']),
      namaPengisi: _sanitize(json['namaPengisi']),
    );
  }
}
