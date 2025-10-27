class KerapianResponse {
  final int status;
  final String message;
  final List<Kerapian> data;

  KerapianResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KerapianResponse.fromJson(Map<String, dynamic> json) {
    return KerapianResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => Kerapian.fromJson(item))
          .toList(),
    );
  }
}

class Kerapian {
  final String id;
  final String tanggal;
  final String nama;
  final String sandal;
  final String sepatu;
  final String boxJajan;
  final String alatMandi;
  final String tindakLanjut;
  final String namaPengisi;

  Kerapian({
    required this.id,
    required this.tanggal,
    required this.nama,
    required this.sandal,
    required this.sepatu,
    required this.boxJajan,
    required this.alatMandi,
    required this.tindakLanjut,
    required this.namaPengisi,
  });

  factory Kerapian.fromJson(Map<String, dynamic> json) {
    return Kerapian(
      id: json['id']?.toString() ?? '-',
      tanggal: json['tanggal']?.toString() ?? '-',
      nama: json['nama']?.toString() ?? '-',
      sandal: json['sandal']?.toString() ?? '-',
      sepatu: json['sepatu']?.toString() ?? '-',
      boxJajan: json['boxJajan']?.toString() ?? '-',
      alatMandi: json['alatMandi']?.toString() ?? '-',
      tindakLanjut: json['tindakLanjut']?.toString() ?? '-',
      namaPengisi: json['namaPengisi']?.toString() ?? '-',
    );
  }
}
