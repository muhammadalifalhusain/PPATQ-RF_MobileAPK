import 'dart:convert';

class About {
  final int status;
  final String message;
  final AboutData data;

  About({
    required this.status,
    required this.message,
    required this.data,
  });

  factory About.fromJson(String source) => About.fromMap(json.decode(source));

  factory About.fromMap(Map<String, dynamic> json) {
    return About(
      status: json["status"],
      message: json["message"],
      data: AboutData.fromMap(json["data"]),
    );
  }
}

class AboutData {
  final String tentang;
  final String visi;
  final String misi;
  final String alamat;
  final String sekolah;
  final String nsm;
  final String npsn;
  final String naraHubung;

  AboutData({
    required this.tentang,
    required this.visi,
    required this.misi,
    required this.alamat,
    required this.sekolah,
    required this.nsm,
    required this.npsn,
    required this.naraHubung,
  });

  factory AboutData.fromMap(Map<String, dynamic> json) {
    return AboutData(
      tentang: json["tentang"],
      visi: json["visi"],
      misi: json["misi"],
      alamat: json["alamat"],
      sekolah: json["sekolah"],
      nsm: json["nsm"],
      npsn: json["npsn"],
      naraHubung: json["nara_hubung"],
    );
  }
}
