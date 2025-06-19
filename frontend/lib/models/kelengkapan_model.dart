class KelengkapanResponse {
  final int status;
  final String message;
  final List<Kelengkapan> data;

  KelengkapanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KelengkapanResponse.fromJson(Map<String, dynamic> json) {
    return KelengkapanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => Kelengkapan.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Kelengkapan {
  final String tanggal;
  final String perlengkapanMandi;
  final String catatanMandi;
  final String peralatanSekolah;
  final String catatanSekolah;
  final String perlengkapanDiri;
  final String catatanDiri;

  Kelengkapan({
    required this.tanggal,
    required this.perlengkapanMandi,
    required this.catatanMandi,
    required this.peralatanSekolah,
    required this.catatanSekolah,
    required this.perlengkapanDiri,
    required this.catatanDiri,
  });

  factory Kelengkapan.fromJson(Map<String, dynamic> json) {
    return Kelengkapan(
      tanggal: json['tanggal'] ?? '',
      perlengkapanMandi: json['perlengkapanMandi'] ?? '-',
      catatanMandi: json['catatanMandi'] ?? '-',
      peralatanSekolah: json['peralatanSekolah'] ?? '-',
      catatanSekolah: json['catatanSekolah'] ?? '-',
      perlengkapanDiri: json['perlengkapanDiri'] ?? '-',
      catatanDiri: json['catatanDiri'] ?? '-',
    );
  }
}
