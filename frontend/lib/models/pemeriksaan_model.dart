class Pemeriksaan {
  final int tanggalPemeriksaan;
  final int tinggiBadan;
  final int beratBadan;
  final int lingkarPinggul;
  final int lingkarDada;
  final String kondisiGigi;

  Pemeriksaan({
    required this.tanggalPemeriksaan,
    required this.tinggiBadan,
    required this.beratBadan,
    required this.lingkarPinggul,
    required this.lingkarDada,
    required this.kondisiGigi,
  });

  factory Pemeriksaan.fromJson(Map<String, dynamic> json) {
    return Pemeriksaan(
      tanggalPemeriksaan: json['tanggal_pemeriksaan'],
      tinggiBadan: json['tinggi_badan'],
      beratBadan: json['berat_badan'],
      lingkarPinggul: json['lingkar_pinggul'],
      lingkarDada: json['lingkar_dada'],
      kondisiGigi: json['kondisi_gigi'],
    );
  }
}
