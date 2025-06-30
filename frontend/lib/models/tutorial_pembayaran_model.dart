class TutorialPembayaran {
  final int? id;
  final int urutan;
  final String jenis;
  final String teks;

  TutorialPembayaran({
    required this.id,
    required this.urutan,
    required this.jenis,
    required this.teks,
  });

  factory TutorialPembayaran.fromJson(Map<String, dynamic> json) {
    return TutorialPembayaran(
      id: json['id'],
      urutan: json['urutan'] is String
          ? int.tryParse(json['urutan']) ?? 0
          : json['urutan'] ?? 0,
      jenis: json['jenis'] ?? '',
      teks: json['teks'] ?? '',
    );
  }
}

class TutorialPembayaranResponse {
  final int status;
  final String message;
  final List<TutorialPembayaran> data;

  TutorialPembayaranResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory TutorialPembayaranResponse.fromJson(Map<String, dynamic> json) {
    return TutorialPembayaranResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List)
          .map((item) => TutorialPembayaran.fromJson(item))
          .toList(),
    );
  }
}
