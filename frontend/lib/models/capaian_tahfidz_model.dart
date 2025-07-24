class CapaianTahfidzResponse {
  final int status;
  final String message;
  final CapaianTahfidzData data;

  CapaianTahfidzResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CapaianTahfidzResponse.fromJson(Map<String, dynamic> json) {
    return CapaianTahfidzResponse(
      status: json['status'],
      message: json['message'],
      data: CapaianTahfidzData.fromJson(json['data']),
    );
  }
}

class CapaianTahfidzData {
  final CapaianItem tertinggi;
  final CapaianItem terendah;

  CapaianTahfidzData({
    required this.tertinggi,
    required this.terendah,
  });

  factory CapaianTahfidzData.fromJson(Map<String, dynamic> json) {
    return CapaianTahfidzData(
      tertinggi: CapaianItem.fromJson(json['tertinggi']),
      terendah: CapaianItem.fromJson(json['terendah']),
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
      capaian: json['capaian'],
      jumlah: json['jumlah'],
      santri: List<SantriTahfidz>.from(
        json['santri'].map((x) => SantriTahfidz.fromJson(x)),
      ),
    );
  }
}

class SantriTahfidz {
  final String nama;
  final String? photo;
  final String kelas;
  final String guruTahfidz;

  SantriTahfidz({
    required this.nama,
    required this.photo,
    required this.kelas,
    required this.guruTahfidz,
  });

  factory SantriTahfidz.fromJson(Map<String, dynamic> json) {
    return SantriTahfidz(
      nama: json['nama'],
      photo: json['photo'],
      kelas: json['kelas'],
      guruTahfidz: json['guruTahfidz'],
    );
  }
}
