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
    final jumlahValue = _parseInt(json['jumlah']);
    return SakuMasuk(
      uangAsal: _parseString(json['uangAsal']),
      jumlah: jumlahValue,
      tanggal: _parseString(json['tanggal']),
    );
  }

  Map<String, dynamic> toJson() => {
    'uangAsal': uangAsal,
    'jumlah': jumlah,
    'tanggal': tanggal,
  };
}

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
    final jumlahValue = _parseInt(json['jumlah']);
    return SakuKeluar(
      nama: _parseString(json['nama']),
      jumlah: jumlahValue,
      note: _parseString(json['note']),
      tanggal: _parseString(json['tanggal']),
    );
  }

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'jumlah': jumlah,
    'note': note,
    'tanggal': tanggal,
  };
}

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
    final saldoValue = _parseInt(json['saldo']);
    return Keuangan(
      saldo: saldoValue,
      sakuMasuk: (json['sakuMasuk'] as List?)?.map((e) => SakuMasuk.fromJson(e)).toList() ?? [],
      sakuKeluar: (json['sakuKeluar'] as List?)?.map((e) => SakuKeluar.fromJson(e)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'saldo': saldo,
    'sakuMasuk': sakuMasuk.map((e) => e.toJson()).toList(),
    'sakuKeluar': sakuKeluar.map((e) => e.toJson()).toList(),
  };
}

class LoginResponse {
  final int noInduk;
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
    return LoginResponse(
      noInduk: _parseInt(json['noInduk']),
      nama: _parseString(json['nama']),
      photo: _parseString(json['photo']),
      kelas: _parseString(json['kelas']),
      kelasTahfidz: _parseString(json['kelasTahfidz']),
      tempatLahir: _parseString(json['tempatLahir']),
      tanggalLahir: _parseString(json['tanggalLahir']),
      jenisKelamin: _parseString(json['jenisKelamin']),
      alamat: _parseString(json['alamat']),
      namaAyah: _parseString(json['namaAyah']),
      pendidikanAyah: _parseString(json['pendidikanAyah']),
      pekerjaanAyah: _parseString(json['pekerjaanAyah']),
      namaIbu: _parseString(json['namaIbu']),
      pendidikanIbu: _parseString(json['pendidikanIbu']),
      pekerjaanIbu: _parseString(json['pekerjaanIbu']),
      noHp: _parseString(json['noHp']),
      kamar: _parseString(json['kamar']),
      namaMurroby: _parseString(json['namaMurroby']),
      fotoMurroby: _parseString(json['fotoMurroby']),
      namaUstadTahfidz: _parseString(json['namaUstadTahfidz']),
      fotoUstadTahfidz: _parseString(json['fotoUstadTahfidz']),
      keuangan: json['keuangan'] is Map<String, dynamic>
          ? Keuangan.fromJson(json['keuangan'])
          : Keuangan(saldo: 0, sakuMasuk: [], sakuKeluar: []),
    );
  }

  Map<String, dynamic> toJson() => {
    'noInduk': noInduk,
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

class ApiResponse<T> {
  final T data;

  ApiResponse({required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      data: fromJsonT(json['data']),
    );
  }
}

int _parseInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _parseString(dynamic value) {
  if (value == null || (value is String && value.trim().isEmpty)) return '';
  return value.toString();
}
