class KategoriKeluhan {
  final int id;
  final String nama;

  KategoriKeluhan({required this.id, required this.nama});

  factory KategoriKeluhan.fromJson(Map<String, dynamic> json) {
    return KategoriKeluhan(
      id: json['id'],
      nama: json['nama'],
    );
  }
}
