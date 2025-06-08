class DetailSantri {
  final String nama;
  final int noInduk;

  DetailSantri({required this.nama, required this.noInduk});

  factory DetailSantri.fromJson(Map<String, dynamic> json) {
    return DetailSantri(
      nama: json['nama'],
      noInduk: json['noInduk'],
    );
  }
}

class Juz {
  final String tanggal;
  final int kode;
  final String nmJuz;

  Juz({required this.tanggal, required this.kode, required this.nmJuz});

  factory Juz.fromJson(Map<String, dynamic> json) {
    return Juz(
      tanggal: json['tanggal'],
      kode: json['kode'],
      nmJuz: json['nmJuz'],
    );
  }
}

class Ketahfidzan {
  final Map<String, Map<String, List<Juz>>> data;

  Ketahfidzan({required this.data});

  factory Ketahfidzan.fromJson(Map<String, dynamic> json) {
    var dataMap = json['ketahfidzan'] as Map<String, dynamic>;
    Map<String, Map<String, List<Juz>>> parsedData = {};

    dataMap.forEach((year, months) {
      var monthMap = months as Map<String, dynamic>;
      Map<String, List<Juz>> parsedMonths = {};
      monthMap.forEach((month, juzList) {
        parsedMonths[month] = (juzList as List).map((juz) => Juz.fromJson(juz)).toList();
      });
      parsedData[year] = parsedMonths;
    });

    return Ketahfidzan(data: parsedData);
  }
}

class ApiResponse {
  final int status;
  final String message;
  final DetailSantri detailSantri;
  final Ketahfidzan ketahfidzan;

  ApiResponse({required this.status, required this.message, required this.detailSantri, required this.ketahfidzan});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'],
      message: json['message'],
      detailSantri: DetailSantri.fromJson(json['data']['detailSantri'][0]),
      ketahfidzan: Ketahfidzan.fromJson(json['data']),
    );
  }
}