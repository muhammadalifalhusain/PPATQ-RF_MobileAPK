class CapaianTahfidzResponse {
  final int status;
  final String message;
  final CapaianTahfidzData? data;

  CapaianTahfidzResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory CapaianTahfidzResponse.fromJson(Map<String, dynamic> json) {
    return CapaianTahfidzResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? CapaianTahfidzData.fromJson(json['data']) : null,
    );
  }
}

class CapaianTahfidzData {
  final List<CapaianItem> capaianCustom;
  final CapaianItem? terendah;

  CapaianTahfidzData({
    required this.capaianCustom,
    this.terendah,
  });

  factory CapaianTahfidzData.fromJson(Map<String, dynamic> json) {
    return CapaianTahfidzData(
      capaianCustom: (json['capaianCustom'] as List? ?? [])
          .map((e) => CapaianItem.fromJson(e ?? {}))
          .toList(),
      terendah: json['terendah'] != null ? CapaianItem.fromJson(json['terendah']) : null,
    );
  }
}

class CapaianItem {
  final String capaian;
  final int jumlah;
  final List<SantriTahfidz> santri;

  CapaianItem({
    required this.capaian,
    required this.jumlah,
    required this.santri,
  });

  factory CapaianItem.fromJson(Map<String, dynamic> json) {
    return CapaianItem(
      capaian: json['capaian'] ?? '',
      jumlah: json['jumlah'] ?? 0,
      santri: (json['santri'] as List? ?? [])
          .map((e) => SantriTahfidz.fromJson(e ?? {}))
          .toList(),
    );
  }
}

class SantriTahfidz {
  final String nama;
  final String? photo;
  final String kelas;
  final String? guruTahfidz;
  final String? photoUstadTahfidz;

  SantriTahfidz({
    required this.nama,
    this.photo,
    required this.kelas,
    this.guruTahfidz,
    this.photoUstadTahfidz,
  });

  factory SantriTahfidz.fromJson(Map<String, dynamic> json) {
    return SantriTahfidz(
      nama: json['nama'] ?? '',
      photo: (json['photo'] != null && (json['photo'] as String).isNotEmpty)
          ? json['photo']
          : null,
      kelas: json['kelas'] ?? '',
      guruTahfidz: (json['guruTahfidz'] != null && (json['guruTahfidz'] as String).isNotEmpty)
          ? json['guruTahfidz']
          : null,
      photoUstadTahfidz: (json['photoUstadTahfidz'] != null && (json['photoUstadTahfidz'] as String).isNotEmpty)
          ? json['photoUstadTahfidz']
          : null,
    );
  }
}
