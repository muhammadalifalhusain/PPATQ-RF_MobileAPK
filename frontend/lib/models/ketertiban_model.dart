class KetertibanResponse {
  final int status;
  final String message;
  final List<Ketertiban> data;

  KetertibanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KetertibanResponse.fromJson(Map<String, dynamic> json) {
    return KetertibanResponse(
      status: json['status'],
      message: json['message'],
      data: List<Ketertiban>.from(
        json['data'].map((item) => Ketertiban.fromJson(item)),
      ),
    );
  }
}

class Ketertiban {
  final String id;
  final String tanggal;
  final String nama;
  final String buangSampah;
  final String menataPeralatan;
  final String tidakBerseragam;
  final String namaPengisi;

  Ketertiban({
    required this.id,
    required this.tanggal,
    required this.nama,
    required this.buangSampah,
    required this.menataPeralatan,
    required this.tidakBerseragam,
    required this.namaPengisi,
  });

  factory Ketertiban.fromJson(Map<String, dynamic> json) {
    return Ketertiban(
      id: json['id'],
      tanggal: json['tanggal'],
      nama: json['nama'],
      buangSampah: json['buangSampah'],
      menataPeralatan: json['menataPeralatan'],
      tidakBerseragam: json['tidakBerseragam'],
      namaPengisi: json['namaPengisi'],
    );
  }
}
