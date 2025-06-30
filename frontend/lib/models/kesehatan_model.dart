class KesehatanResponse {
  final int status;
  final String message;
  final KesehatanData data;

  KesehatanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KesehatanResponse.fromJson(Map<String, dynamic> json) {
    return KesehatanResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? KesehatanData.fromJson(json['data'])
          : KesehatanData.empty(),
    );
  }
}

class KesehatanData {
  final List<RiwayatSakit> riwayatSakit;
  final List<Pemeriksaan> pemeriksaan;
  final List<RawatInap> rawatInap;

  KesehatanData({
    required this.riwayatSakit,
    required this.pemeriksaan,
    required this.rawatInap,
  });

  factory KesehatanData.fromJson(Map<String, dynamic> json) {
    return KesehatanData(
      riwayatSakit: (json['riwayatSakit'] as List?)
              ?.map((x) => RiwayatSakit.fromJson(x))
              .toList() ??
          [],
      pemeriksaan: (json['pemeriksaan'] as List?)
              ?.map((x) => Pemeriksaan.fromJson(x))
              .toList() ??
          [],
      rawatInap: (json['rawatInap'] as List?)
              ?.map((x) => RawatInap.fromJson(x))
              .toList() ??
          [],
    );
  }

  factory KesehatanData.empty() {
    return KesehatanData(
      riwayatSakit: [],
      pemeriksaan: [],
      rawatInap: [],
    );
  }
}

class RiwayatSakit {
  final String keluhan;
  final int tanggalSakit;
  final int? tanggalSembuh;
  final String keteranganSakit;
  final String? keteranganSembuh;
  final String? tindakan;

  RiwayatSakit({
    required this.keluhan,
    required this.tanggalSakit,
    this.tanggalSembuh,
    required this.keteranganSakit,
    this.keteranganSembuh,
    this.tindakan,
  });

  factory RiwayatSakit.fromJson(Map<String, dynamic> json) {
    return RiwayatSakit(
      keluhan: json['keluhan'] ?? '',
      tanggalSakit: json['tanggalSakit'] ?? 0,
      tanggalSembuh: json['tanggalSembuh'],
      keteranganSakit: json['keteranganSakit'] ?? '',
      keteranganSembuh: json['keteranganSembuh'],
      tindakan: json['tindakan'],
    );
  }

  DateTime get tanggalSakitDate =>
      DateTime.fromMillisecondsSinceEpoch(tanggalSakit * 1000);

  DateTime? get tanggalSembuhDate => tanggalSembuh != null
      ? DateTime.fromMillisecondsSinceEpoch(tanggalSembuh! * 1000)
      : null;
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
      tanggalPemeriksaan: json['tanggalPemeriksaan'] ?? 0,
      tinggiBadan: json['tinggiBadan'] ?? 0,
      beratBadan: json['beratBadan'] ?? 0,
      lingkarPinggul: json['lingkarPinggul'],
      lingkarDada: json['lingkarDada'],
      kondisiGigi: json['kondisiGigi'],
    );
  }
}

class RawatInap {
  final int tanggalMasuk;
  final String keluhan;
  final String terapi;
  final int? tanggalKeluar;

  RawatInap({
    required this.tanggalMasuk,
    required this.keluhan,
    required this.terapi,
    this.tanggalKeluar,
  });

  factory RawatInap.fromJson(Map<String, dynamic> json) {
    return RawatInap(
      tanggalMasuk: json['tanggalMasuk'] ?? 0,
      keluhan: json['keluhan'] ?? '',
      terapi: json['terapi'] ?? '',
      tanggalKeluar: json['tanggalKeluar'],
    );
  }

  DateTime get tanggalMasukDate =>
      DateTime.fromMillisecondsSinceEpoch(tanggalMasuk * 1000);

  DateTime? get tanggalKeluarDate => tanggalKeluar != null
      ? DateTime.fromMillisecondsSinceEpoch(tanggalKeluar! * 1000)
      : null;
}
