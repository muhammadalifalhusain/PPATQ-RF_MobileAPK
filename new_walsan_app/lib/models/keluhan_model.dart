class Keluhan {
  final String namaPelapor;
  final String email;
  final String noHp;
  final int? idSantri;
  final String namaWaliSantri;
  final int? idKategori;
  final String masukan;
  final String saran;
  final int rating;
  final String jenis;

  Keluhan({
    required this.namaPelapor,
    required this.email,
    required this.noHp,
    this.idSantri,
    required this.namaWaliSantri,
    this.idKategori,
    required this.masukan,
    required this.saran,
    required this.rating,
    required this.jenis,
  });

  Map<String, dynamic> toJson() {
    return {
      'namaPelapor': namaPelapor,
      'email': email,
      'noHp': noHp,
      'namaSantri': idSantri,
      'namaWaliSantri': namaWaliSantri,
      'kategori': idKategori,
      'masukan': masukan,
      'saran': saran,
      'rating': rating,
      'jenis': jenis,
    };
  }
}


class KeluhanResponse {
  final int status;
  final String message;
  final List<KeluhanItem> ditangani;
  final List<KeluhanItem> belumDitangani;

  KeluhanResponse({
    required this.status,
    required this.message,
    required this.ditangani,
    required this.belumDitangani,
  });

  factory KeluhanResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];

    final dataMap = (rawData is Map<String, dynamic>) ? rawData : {};

    return KeluhanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      belumDitangani: (dataMap['Belum Ditangani'] as List<dynamic>? ?? [])
          .map((item) => KeluhanItem.fromJson(item ?? {}))
          .toList(),
      ditangani: (dataMap['Ditangani'] as List<dynamic>? ?? [])
          .map((item) => KeluhanItem.fromJson(item ?? {}))
          .toList(),
    );
  }

}

class KeluhanItem {
  final int idKeluhan;
  final int? idBalasan;
  final String namaPelapor;
  final String email;
  final String? noHp;
  final String namaSantri;
  final String namaWaliSantri;
  final String kategori;
  final String jenis;
  final String status;
  final String masukan;
  final String saran;
  final int rating;
  final String? balasan;
  final DateTime createdAt;
  final String? diuploadPada;

  KeluhanItem({
    required this.idKeluhan,
    this.idBalasan,
    required this.namaPelapor,
    required this.email,
    this.noHp,
    required this.namaSantri,
    required this.namaWaliSantri,
    required this.kategori,
    required this.jenis,
    required this.status,
    required this.masukan,
    required this.saran,
    required this.rating,
    this.balasan,
    required this.createdAt,
    this.diuploadPada
  });

  factory KeluhanItem.fromJson(Map<String, dynamic> json) {
    return KeluhanItem(
      idKeluhan: json['idKeluhan'] ?? 0,
      idBalasan: json['idBalasan'],
      namaPelapor: json['namaPelapor'] ?? '',
      email: json['email'] ?? '',
      noHp: json['noHp']?.toString(),
      namaSantri: json['namaSantri'] ?? '',
      namaWaliSantri: json['namaWaliSantri'] ?? '',
      kategori: json['kategori'] ?? '',
      jenis: json['jenis'] ?? '',
      status: json['status'] ?? '',
      masukan: json['masukan'] ?? '',
      saran: json['saran'] ?? '',
      rating: json['rating'] ?? 0,
      balasan: json['balasan']?.toString(),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime(2000),
      diuploadPada: json['diuploadPada'],
    );
  }
}
