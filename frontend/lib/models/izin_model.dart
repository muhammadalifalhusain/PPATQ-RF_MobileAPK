class IzinResponse {
  final int status;
  final String message;
  final List<IzinData> data;

  IzinResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory IzinResponse.fromJson(Map<String, dynamic> json) {
    return IzinResponse(
      status: json['status'] ?? 0,
      message: (json['message'] ?? '').toString(),
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => IzinData.fromJson(e))
          .toList(),
    );
  }
}

class IzinData {
  final String id;
  final String nama;
  final String tanggal;
  final String keluar;
  final String kembali;
  final String status;
  final String kategori;
  final String kategoriPelanggaran;
  final String namaPengisi;

  IzinData({
    required this.id,
    required this.nama,
    required this.tanggal,
    required this.keluar,
    required this.kembali,
    required this.status,
    required this.kategori,
    required this.kategoriPelanggaran,
    required this.namaPengisi,
  });

  factory IzinData.fromJson(Map<String, dynamic> json) {
    String _sanitize(dynamic value) {
      final str = value?.toString().trim();
      return (str == null || str.isEmpty || str == '-') ? '-' : str;
    }

    return IzinData(
      id: _sanitize(json['id']),
      nama: _sanitize(json['nama']),
      tanggal: _sanitize(json['tanggal']),
      keluar: _sanitize(json['keluar']),
      kembali: _sanitize(json['kembali']),
      status: _sanitize(json['status']),
      kategori: _sanitize(json['kategori']),
      kategoriPelanggaran: _sanitize(json['kategoriPelanggaran']),
      namaPengisi: _sanitize(json['namaPengisi']),
    );
  }
}
