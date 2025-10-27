class Kelas {
  final String kode;

  Kelas({required this.kode});

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(kode: json['kode']);
  }
}
