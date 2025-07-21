class GaleriResponse {
  final int status;
  final String message;
  final GaleriData data;

  GaleriResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory GaleriResponse.fromJson(Map<String, dynamic> json) {
    return GaleriResponse(
      status: json['status'],
      message: json['message'],
      data: GaleriData.fromJson(json['data']),
    );
  }
}

class GaleriData {
  final List<GaleriItem> galeri;
  final List<GaleriItem> fasilitas;

  GaleriData({
    required this.galeri,
    required this.fasilitas,
  });

  factory GaleriData.fromJson(Map<String, dynamic> json) {
    return GaleriData(
      galeri: List<GaleriItem>.from(json['galeri'].map((x) => GaleriItem.fromJson(x))),
      fasilitas: List<GaleriItem>.from(json['fasilitas'].map((x) => GaleriItem.fromJson(x))),
    );
  }
}

class GaleriItem {
  final String nama;
  final String? deskripsi;
  final String foto;
  final int published;

  GaleriItem({
    required this.nama,
    required this.deskripsi,
    required this.foto,
    required this.published,
  });

  factory GaleriItem.fromJson(Map<String, dynamic> json) {
    return GaleriItem(
      nama: json['nama'],
      deskripsi: json['deskripsi'],
      foto: json['foto'],
      published: json['published'],
    );
  }
}
