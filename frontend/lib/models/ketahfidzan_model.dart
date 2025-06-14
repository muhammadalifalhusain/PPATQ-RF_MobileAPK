class KetahfidzanResponse {
  final int status;
  final String message;
  final SantriData data;

  KetahfidzanResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KetahfidzanResponse.fromJson(Map<String, dynamic> json) {
    return KetahfidzanResponse(
      status: json['status'],
      message: json['message'],
      data: SantriData.fromJson(json['data']),
    );
  }
}

class SantriData {
  final List<DetailSantri> detailSantri;
  final Map<String, Map<String, List<KetahfidzanEntry>>> ketahfidzan;

  SantriData({
    required this.detailSantri,
    required this.ketahfidzan,
  });

  factory SantriData.fromJson(Map<String, dynamic> json) {
    final detailSantriList = (json['detailSantri'] as List)
        .map((e) => DetailSantri.fromJson(e))
        .toList();

    final rawKetahfidzan = json['ketahfidzan'];

    Map<String, Map<String, List<KetahfidzanEntry>>> parsedKetahfidzan = {};

    if (rawKetahfidzan is Map<String, dynamic>) {
      parsedKetahfidzan = rawKetahfidzan.map(
        (year, months) => MapEntry(
          year,
          (months as Map<String, dynamic>).map(
            (month, entries) => MapEntry(
              month,
              (entries as List)
                  .map((e) => KetahfidzanEntry.fromJson(e))
                  .toList(),
            ),
          ),
        ),
      );
    }

    return SantriData(
      detailSantri: detailSantriList,
      ketahfidzan: parsedKetahfidzan,
    );
  }
}

class DetailSantri {
  final String nama;
  final int noInduk;

  DetailSantri({
    required this.nama,
    required this.noInduk,
  });

  factory DetailSantri.fromJson(Map<String, dynamic> json) {
    return DetailSantri(
      nama: json['nama'],
      noInduk: json['noInduk'],
    );
  }
}

class KetahfidzanEntry {
  final String tanggalTahfidzan;
  final String nmJuz;

  KetahfidzanEntry({
    required this.tanggalTahfidzan,
    required this.nmJuz,
  });

  factory KetahfidzanEntry.fromJson(Map<String, dynamic> json) {
    return KetahfidzanEntry(
      tanggalTahfidzan: json['tanggalTahfidzan'],
      nmJuz: json['nmJuz'],
    );
  }
}
