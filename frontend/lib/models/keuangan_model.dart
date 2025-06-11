class KeuanganResponse {
  final int status;
  final String message;
  final KeuanganData data;

  KeuanganResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory KeuanganResponse.fromJson(Map<String, dynamic> json) {
    return KeuanganResponse(
      status: json['status'],
      message: json['message'],
      data: KeuanganData.fromJson(json['data']),
    );
  }
}

class KeuanganData {
  final DataSantri dataSantri;
  final List<UangMasuk>? dataUangMasuk;
  final List<UangKeluar>? dataUangKeluar;

  KeuanganData({
    required this.dataSantri,
    this.dataUangMasuk,
    this.dataUangKeluar,
  });

  factory KeuanganData.fromJson(Map<String, dynamic> json) {
    return KeuanganData(
      dataSantri: DataSantri.fromJson(json['dataSantri']),
      dataUangMasuk: json['dataUangMasuk'] != null
          ? (json['dataUangMasuk'] as List)
              .map((e) => UangMasuk.fromJson(e))
              .toList()
          : null,
      dataUangKeluar: json['dataUangKeluar'] != null
          ? (json['dataUangKeluar'] as List)
              .map((e) => UangKeluar.fromJson(e))
              .toList()
          : null,
    );
  }
}

class DataSantri {
  final int noInduk;
  final String namaSantri;

  DataSantri({
    required this.noInduk,
    required this.namaSantri,
  });

  factory DataSantri.fromJson(Map<String, dynamic> json) {
    return DataSantri(
      noInduk: json['noInduk'],
      namaSantri: json['namaSantri'],
    );
  }
}

class UangMasuk {
  final String uangAsal;
  final int jumlahMasuk;
  final String tanggalTransaksi;

  UangMasuk({
    required this.uangAsal,
    required this.jumlahMasuk,
    required this.tanggalTransaksi,
  });

  factory UangMasuk.fromJson(Map<String, dynamic> json) {
    return UangMasuk(
      uangAsal: json['uangAsal'] ?? '',
      jumlahMasuk: json['jumlahMasuk'] ?? 0,
      tanggalTransaksi: json['tanggalTransaksi'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uangAsal': uangAsal,
      'jumlahMasuk': jumlahMasuk,
      'tanggalTransaksi': tanggalTransaksi,
    };
  }
}

class UangKeluar {
  final int jumlahKeluar;
  final String catatan;
  final String tanggalTransaksi;
  final String namaMurroby;

  UangKeluar({
    required this.jumlahKeluar,
    required this.catatan,
    required this.tanggalTransaksi,
    required this.namaMurroby,
  });

  factory UangKeluar.fromJson(Map<String, dynamic> json) {
    return UangKeluar(
      jumlahKeluar: json['jumlahKeluar'],
      catatan: json['catatan'],
      tanggalTransaksi: json['tanggalTransaksi'],
      namaMurroby: json['namaMurroby'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jumlahKeluar': jumlahKeluar,
      'catatan': catatan,
      'tanggalTransaksi': tanggalTransaksi,
      'namaMurroby': namaMurroby,
    };
  }
}