class Kesehatan {
  final String noInduk;
  final String namaSantri;
  final List<Pemeriksaan> pemeriksaan;

  Kesehatan({
    required this.noInduk,
    required this.namaSantri,
    required this.pemeriksaan,
  });

  factory Kesehatan.fromJson(Map<String, dynamic> json) {
    return Kesehatan(
      noInduk: json['no_induk'],
      namaSantri: json['nama_santri'],
      pemeriksaan: (json['data'] as List<dynamic>?)
          ?.map((e) => Pemeriksaan.fromJson(e))
          .toList() ?? [],
    );
  }
}

class Pemeriksaan {
  final int tanggalPemeriksaan;
  final int tinggiBadan;
  final int beratBadan;
  final int? lingkarPinggul;
  final int? lingkarDada;
  final String? kondisiGigi;

  Pemeriksaan({
    required this.tanggalPemeriksaan,
    required this.tinggiBadan,
    required this.beratBadan,
    this.lingkarPinggul,
    this.lingkarDada,
    this.kondisiGigi,
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
