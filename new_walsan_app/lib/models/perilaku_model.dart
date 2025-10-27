class PerilakuResponse {
  final int status;
  final String message;
  final List<Perilaku> data;

  PerilakuResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PerilakuResponse.fromJson(Map<String, dynamic> json) {
    return PerilakuResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Perilaku.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Perilaku {
  final String tanggal;
  final String ketertiban;
  final String kebersihan;
  final String kedisiplinan;
  final String kerapian;
  final String kesopanan;
  final String kepekaanLingkungan;
  final String ketaatanPeraturan;

  Perilaku({
    required this.tanggal,
    required this.ketertiban,
    required this.kebersihan,
    required this.kedisiplinan,
    required this.kerapian,
    required this.kesopanan,
    required this.kepekaanLingkungan,
    required this.ketaatanPeraturan,
  });

  factory Perilaku.fromJson(Map<String, dynamic> json) {
    return Perilaku(
      tanggal: json['tanggal'] ?? '',
      ketertiban: json['ketertiban'] ?? '-',
      kebersihan: json['kebersihan'] ?? '-',
      kedisiplinan: json['kedisiplinan'] ?? '-',
      kerapian: json['kerapian'] ?? '-',
      kesopanan: json['kesopanan'] ?? '-',
      kepekaanLingkungan: json['kepekaanLingkungan'] ?? '-',
      ketaatanPeraturan: json['ketaatanPeraturan'] ?? '-',
    );
  }
}
