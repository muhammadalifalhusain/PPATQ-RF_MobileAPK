class Kesehatan {
  final String noInduk;
  final String namaSantri;
  final List<Map<String, dynamic>> pemeriksaan; // List untuk menyimpan semua pemeriksaan

  Kesehatan({
    required this.noInduk,
    required this.namaSantri,
    required this.pemeriksaan,
  });

  factory Kesehatan.fromJson(Map<String, dynamic> json) {
    return Kesehatan(
      noInduk: json['no_induk'],
      namaSantri: json['nama_santri'],
      pemeriksaan: [], // Akan diisi dalam parsing utama
    );
  }
}
