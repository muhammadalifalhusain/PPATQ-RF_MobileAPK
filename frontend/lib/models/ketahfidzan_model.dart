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
    return SantriData(
      detailSantri: (json['detailSantri'] as List)
          .map((e) => DetailSantri.fromJson(e))
          .toList(),
      ketahfidzan: (json['ketahfidzan'] as Map<String, dynamic>).map(
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
      ),
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
  final String tanggal;
  final int kode;
  final String nmJuz;

  KetahfidzanEntry({
    required this.tanggal,
    required this.kode,
    required this.nmJuz,
  });

  factory KetahfidzanEntry.fromJson(Map<String, dynamic> json) {
    return KetahfidzanEntry(
      tanggal: json['tanggal'],
      kode: json['kode'],
      nmJuz: json['nmJuz'],
    );
  }
}
