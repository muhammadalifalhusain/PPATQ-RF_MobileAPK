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

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.toJson(),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'detailSantri': detailSantri.map((e) => e.toJson()).toList(),
      'ketahfidzan': ketahfidzan.map(
        (year, months) => MapEntry(
          year,
          months.map(
            (month, entries) => MapEntry(
              month,
              entries.map((e) => e.toJson()).toList(),
            ),
          ),
        ),
      ),
    };
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

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'noInduk': noInduk,
    };
  }
}

class KetahfidzanEntry {
  final String tanggal;
  final String hafalan;
  final String tilawah;
  final String kefasihan;
  final String dayaIngat;
  final String kelancaran;
  final String praktekTajwid;
  final String makhroj;
  final String tanafus;
  final String waqofWasol;
  final String ghorib;
  final String nmJuz;
  final String tanggalTahfidzan;

  KetahfidzanEntry({
    required this.tanggal,
    required this.hafalan,
    required this.tilawah,
    required this.kefasihan,
    required this.dayaIngat,
    required this.kelancaran,
    required this.praktekTajwid,
    required this.makhroj,
    required this.tanafus,
    required this.waqofWasol,
    required this.ghorib,
    required this.nmJuz,
    required this.tanggalTahfidzan,
  });

  factory KetahfidzanEntry.fromJson(Map<String, dynamic> json) {
    return KetahfidzanEntry(
      tanggal: json['tanggal'],
      hafalan: json['hafalan'],
      tilawah: json['tilawah'],
      kefasihan: json['kefasihan'],
      dayaIngat: json['dayaIngat'],
      kelancaran: json['kelancaran'],
      praktekTajwid: json['praktekTajwid'],
      makhroj: json['makhroj'],
      tanafus: json['tanafus'],
      waqofWasol: json['waqofWasol'],
      ghorib: json['ghorib'],
      nmJuz: json['nmJuz'],
      tanggalTahfidzan: json['tanggalTahfidzan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tanggal': tanggal,
      'hafalan': hafalan,
      'tilawah': tilawah,
      'kefasihan': kefasihan,
      'dayaIngat': dayaIngat,
      'kelancaran': kelancaran,
      'praktekTajwid': praktekTajwid,
      'makhroj': makhroj,
      'tanafus': tanafus,
      'waqofWasol': waqofWasol,
      'ghorib': ghorib,
      'nmJuz': nmJuz,
      'tanggalTahfidzan': tanggalTahfidzan,
    };
  }
}
