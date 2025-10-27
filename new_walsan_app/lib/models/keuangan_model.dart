import 'dart:convert';

class UangResponse {
  final int? status;
  final String? message;
  final DataUang? data;

  UangResponse({
    this.status,
    this.message,
    this.data,
  });

  factory UangResponse.fromJson(Map<String, dynamic> json) {
    return UangResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? DataUang.fromJson(json['data']) : null,
    );
  }

  static UangResponse fromRawJson(String str) =>
      UangResponse.fromJson(json.decode(str));
}

class DataUang {
  final DataSantri? dataSantri;
  final Map<String, Map<String, List<UangMasukItem>>>? dataUangMasuk;
  final Map<String, Map<String, List<UangKeluarItem>>>? dataUangKeluar;

  DataUang({
    this.dataSantri,
    this.dataUangMasuk,
    this.dataUangKeluar,
  });

  factory DataUang.fromJson(Map<String, dynamic> json) {
    return DataUang(
      dataSantri: json['dataSantri'] != null
          ? DataSantri.fromJson(json['dataSantri'])
          : null,
      dataUangMasuk: _parseUangMasuk(json['dataUangMasuk']),
      dataUangKeluar: _parseUangKeluar(json['dataUangKeluar']),
    );
  }

  static Map<String, Map<String, List<UangMasukItem>>>? _parseUangMasuk(
      dynamic json) {
    if (json == null || json is! Map<String, dynamic>) return null;

    return json.map((tahun, bulanMap) {
      final bulanData = (bulanMap as Map<String, dynamic>).map((bulan, list) {
        final parsedList = (list as List<dynamic>?)
                ?.map((item) => UangMasukItem.fromJson(item))
                .toList() ??
            [];
        return MapEntry(bulan, parsedList);
      });
      return MapEntry(tahun, bulanData);
    });
  }

  static Map<String, Map<String, List<UangKeluarItem>>>? _parseUangKeluar(
      dynamic json) {
    if (json == null || json is! Map<String, dynamic>) return null;

    return json.map((tahun, bulanMap) {
      final bulanData = (bulanMap as Map<String, dynamic>).map((bulan, list) {
        final parsedList = (list as List<dynamic>?)
                ?.map((item) => UangKeluarItem.fromJson(item))
                .toList() ??
            [];
        return MapEntry(bulan, parsedList);
      });
      return MapEntry(tahun, bulanData);
    });
  }
}

class DataSantri {
  final int? noInduk;
  final String? namaSantri;

  DataSantri({
    this.noInduk,
    this.namaSantri,
  });

  factory DataSantri.fromJson(Map<String, dynamic> json) {
    return DataSantri(
      noInduk: json['noInduk'] is int
          ? json['noInduk']
          : int.tryParse(json['noInduk']?.toString() ?? ''),
      namaSantri: (json['namaSantri'] ?? '').toString(),
    );
  }
}

class UangMasukItem {
  final String? uangAsal;
  final int? jumlahMasuk;
  final String? tanggalTransaksi;
  final String? teksBulan;

  UangMasukItem({
    this.uangAsal,
    this.jumlahMasuk,
    this.tanggalTransaksi,
    this.teksBulan,
  });

  factory UangMasukItem.fromJson(Map<String, dynamic> json) {
    return UangMasukItem(
      uangAsal: (json['uangAsal'] ?? '').toString(),
      jumlahMasuk: json['jumlahMasuk'] is int
          ? json['jumlahMasuk']
          : int.tryParse(json['jumlahMasuk']?.toString() ?? '0'),
      tanggalTransaksi: (json['tanggalTransaksi'] ?? '').toString(),
      teksBulan: (json['teksBulan'] ?? '').toString(),
    );
  }
}

class UangKeluarItem {
  final int? jumlahKeluar;
  final String? catatan;
  final String? tanggalTransaksi;
  final String? namaMurroby;
  final String? teksBulan;

  UangKeluarItem({
    this.jumlahKeluar,
    this.catatan,
    this.tanggalTransaksi,
    this.namaMurroby,
    this.teksBulan,
  });

  factory UangKeluarItem.fromJson(Map<String, dynamic> json) {
    return UangKeluarItem(
      jumlahKeluar: json['jumlahKeluar'] is int
          ? json['jumlahKeluar']
          : int.tryParse(json['jumlahKeluar']?.toString() ?? '0'),
      catatan: (json['catatan'] ?? '').toString(),
      tanggalTransaksi: (json['tanggalTransaksi'] ?? '').toString(),
      namaMurroby: (json['namaMurroby'] ?? '').toString(),
      teksBulan: (json['teksBulan'] ?? '').toString(),
    );
  }
}
