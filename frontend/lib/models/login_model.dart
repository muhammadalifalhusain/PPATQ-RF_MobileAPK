class SakuMasuk {
  final String uangAsal;
  final int jumlah;
  final String tanggal;

  SakuMasuk({
    required this.uangAsal,
    required this.jumlah,
    required this.tanggal,
  });

  factory SakuMasuk.fromJson(Map<String, dynamic> json) {
    int jumlahValue = 0;
    if (json['jumlah'] is int) {
      jumlahValue = json['jumlah'] as int;
    } else if (json['jumlah'] is String) {
      jumlahValue = int.tryParse(json['jumlah'].toString()) ?? 0;
      print('Warning: jumlah (SakuMasuk) adalah string: ${json['jumlah']}');
    } else {
      print('Error: jumlah (SakuMasuk) bukan int atau string');
    }
    return SakuMasuk(
      uangAsal: json['uangAsal']?.toString() ??  '',
      jumlah: jumlahValue,
      tanggal: json['tanggal']?.toString() ??  '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uangAsal': uangAsal,
      'jumlah': jumlah,
      'tanggal': tanggal,
    };
  }
}

// Model untuk transaksi uang saku keluar
class SakuKeluar {
  final String nama;
  final int jumlah;
  final String note;
  final String tanggal;

  SakuKeluar({
    required this.nama,
    required this.jumlah,
    required this.note,
    required this.tanggal,
  });

  factory SakuKeluar.fromJson(Map<String, dynamic> json) {
    int jumlahValue = 0;
    if (json['jumlah'] is int) {
      jumlahValue = json['jumlah'] as int;
    } else if (json['jumlah'] is String) {
      jumlahValue = int.tryParse(json['jumlah'].toString()) ?? 0;
      print('Warning: jumlah (SakuKeluar) adalah string: ${json['jumlah']}');
    } else {
      print('Error: jumlah (SakuKeluar) bukan int atau string');
    }
    return SakuKeluar(
      nama: json['nama']?.toString() ??  '',
      jumlah: jumlahValue,
      note: json['note']?.toString() ??  '',
      tanggal: json['tanggal']?.toString() ??  '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'jumlah': jumlah,
      'note': note,
      'tanggal': tanggal,
    };
  }
}

// Model untuk data keuangan
class Keuangan {
  final int saldo;
  final List<SakuMasuk> sakuMasuk;
  final List<SakuKeluar> sakuKeluar;

  Keuangan({
    required this.saldo,
    required this.sakuMasuk,
    required this.sakuKeluar,
  });

  factory Keuangan.fromJson(Map<String, dynamic> json) {
    int saldoValue = 0;
    if (json['saldo'] is int) {
      saldoValue = json['saldo'] as int;
    } else if (json['saldo'] is String) {
      saldoValue = int.tryParse(json['saldo'].toString()) ?? 0;
      print('Warning: saldo (Keuangan) adalah string: ${json['saldo']}');
    } else {
      print('Error: saldo (Keuangan) bukan int atau string');
    }
    return Keuangan(
      saldo: saldoValue,
      sakuMasuk: (json['sakuMasuk'] as List<dynamic>?)
              ?.map((item) => SakuMasuk.fromJson(item))
              .toList() ??
          [],
      sakuKeluar: (json['sakuKeluar'] as List<dynamic>?)
              ?.map((item) => SakuKeluar.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'saldo': saldo,
      'sakuMasuk': sakuMasuk.map((item) => item.toJson()).toList(),
      'sakuKeluar': sakuKeluar.map((item) => item.toJson()).toList(),
    };
  }
}

class LoginResponse {
  final int noInduk;
  final String kode;
  final String nama;
  final String photo;
  final String kelas;
  final String kelasTahfidz;
  final String tempatLahir;
  final String tanggalLahir;
  final String jenisKelamin;
  final String alamat;
  final String namaAyah;
  final String pendidikanAyah;
  final String pekerjaanAyah;
  final String namaIbu;
  final String pendidikanIbu;
  final String pekerjaanIbu;
  final String noHp;
  final String kamar;
  final String namaMurroby;
  final String fotoMurroby;
  final String namaUstadTahfidz;
  final String fotoUstadTahfidz;
  final Keuangan keuangan;

  LoginResponse({
    required this.noInduk,
    required this.kode,
    required this.nama,
    required this.photo,
    required this.kelas,
    required this.kelasTahfidz,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.jenisKelamin,
    required this.alamat,
    required this.namaAyah,
    required this.pendidikanAyah,
    required this.pekerjaanAyah,
    required this.namaIbu,
    required this.pendidikanIbu,
    required this.pekerjaanIbu,
    required this.noHp,
    required this.kamar,
    required this.namaMurroby,
    required this.fotoMurroby,
    required this.namaUstadTahfidz,
    required this.fotoUstadTahfidz,
    required this.keuangan,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic>? keuanganJson;
    if (json['keuangan'] is Map<String, dynamic>) {
      keuanganJson = json['keuangan'] as Map<String, dynamic>;
    } else {
      // Tangani kasus ketika keuangan bukan Map<String, dynamic>
      print('Error: keuangan bukan Map<String, dynamic>');
      keuanganJson = {}; // Berikan Map kosong sebagai default
    }

    int noIndukValue = 0;
    if (json['noInduk'] is int) {
      noIndukValue = json['noInduk'] as int;
    } else if (json['noInduk'] is String) {
      noIndukValue = int.tryParse(json['noInduk'] as String) ?? 0; // Coba parse sebagai int
    } else {
      print('Error: noInduk bukan int atau string');
    }

    return LoginResponse(
      noInduk: noIndukValue,
      kode: json['kode']?.toString() ??  '',
      nama: json['nama']?.toString() ??  '',
      photo: json['photo']?.toString() ??  '',
      kelas: json['kelas']?.toString() ??  '',
      kelasTahfidz: json['kelasTahfidz']?.toString() ??  '',
      tempatLahir: json['tempatLahir']?.toString() ??  '',
      tanggalLahir: json['tanggalLahir']?.toString() ??  '',
      jenisKelamin: json['jenisKelamin']?.toString() ??  '',
      alamat: json['alamat']?.toString() ??  '',
      namaAyah: json['namaAyah']?.toString() ??  '',
      pendidikanAyah: json['pendidikanAyah']?.toString() ??  '',
      pekerjaanAyah: json['pekerjaanAyah']?.toString() ??  '',
      namaIbu: json['namaIbu']?.toString() ??  '',
      pendidikanIbu: json['pendidikanIbu']?.toString() ??  '',
      pekerjaanIbu: json['pekerjaanIbu']?.toString() ??  '',
      noHp: json['noHp']?.toString() ??  '',
      kamar: json['kamar']?.toString() ??  '',
      namaMurroby: json['namaMurroby']?.toString() ??  '',
      fotoMurroby: json['fotoMurroby']?.toString() ??  '',
      namaUstadTahfidz: json['namaUstadTahfidz']?.toString() ??  '',
      fotoUstadTahfidz: json['fotoUstadTahfidz']?.toString() ??  '',
      keuangan: json['keuangan'] != null
          ? Keuangan.fromJson(json['keuangan'])
          : Keuangan(saldo: 0, sakuMasuk: [], sakuKeluar: []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noInduk': noInduk,
      'kode': kode,
      'nama': nama,
      'photo': photo,
      'kelas': kelas,
      'kelasTahfidz': kelasTahfidz,
      'tempatLahir': tempatLahir,
      'tanggalLahir': tanggalLahir,
      'jenisKelamin': jenisKelamin,
      'alamat': alamat,
      'namaAyah': namaAyah,
      'pendidikanAyah': pendidikanAyah,
      'pekerjaanAyah': pekerjaanAyah,
      'namaIbu': namaIbu,
      'pendidikanIbu': pendidikanIbu,
      'pekerjaanIbu': pekerjaanIbu,
      'noHp': noHp,
      'kamar': kamar,
      'namaMurroby': namaMurroby,
      'fotoMurroby': fotoMurroby,
      'namaUstadTahfidz': namaUstadTahfidz,
      'fotoUstadTahfidz': fotoUstadTahfidz,
      'keuangan': keuangan.toJson(),
    };
  }
}

// Model untuk API Response wrapper
class ApiResponse<T> {
  final T data;

  ApiResponse({
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      data: fromJsonT(json['data']),
    );
  }
}