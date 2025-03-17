class Agenda {
  final String judul;
  final String tanggalMulai;
  final String tanggalSelesai;

  Agenda({
    required this.judul,
    required this.tanggalMulai,
    required this.tanggalSelesai,
  });

  factory Agenda.fromJson(Map<String, dynamic> json) {
    return Agenda(
      judul: json['judul'] ?? '',
      tanggalMulai: json['tanggal_mulai'] ?? '',
      tanggalSelesai: json['tanggal_selesai'] ?? '',
    );
  }
}
