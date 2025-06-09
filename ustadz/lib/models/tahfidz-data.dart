class TahfidzResponse {
  final int status;
  final String message;
  final List<SantriTahfidz> data;

  TahfidzResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TahfidzResponse.fromJson(Map<String, dynamic> json) {
    return TahfidzResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => SantriTahfidz.fromJson(item))
          .toList(),
    );
  }
}

class SantriTahfidz {
  final int id;
  final int bulan;
  final String namaSantri;
  final String juz;

  SantriTahfidz({
    required this.id,
    required this.bulan,
    required this.namaSantri,
    required this.juz,
  });

  factory SantriTahfidz.fromJson(Map<String, dynamic> json) {
    return SantriTahfidz(
      id: json['id'],
      bulan: json['bulan'],
      namaSantri: json['namaSantri'],
      juz: json['juz'],
    );
  }
}