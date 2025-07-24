class AlumniResponse {
  final int status;
  final String message;
  final int jumlah;
  final AlumniData data;

  AlumniResponse({
    required this.status,
    required this.message,
    required this.jumlah,
    required this.data,
  });

  factory AlumniResponse.fromJson(Map<String, dynamic> json) {
    return AlumniResponse(
      status: json['status'] as int? ?? 0,
      message: json['message'] as String? ?? '',
      jumlah: json['jumlah'] as int? ?? 0,
      data: AlumniData.fromJson(json['data'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class AlumniData {
  final Alumni alumni;
  final List<PerTahun> perTahun;

  AlumniData({
    required this.alumni,
    required this.perTahun,
  });

  factory AlumniData.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return AlumniData(
      alumni: Alumni.fromJson(json['alumni'] as Map<String, dynamic>? ?? {}),
      perTahun: (json['perTahun'] as List<dynamic>? ?? [])
          .map((i) => PerTahun.fromJson(i as Map<String, dynamic>? ?? {}))
          .toList(),
    );
  }
}

class Alumni {
  final int currentPage;
  final List<AlumniDetail> data;
  final String firstPageUrl;
  final int from;
  final int lastPage;
  final String lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final int to;
  final int total;

  Alumni({
    required this.currentPage,
    required this.data,
    required this.firstPageUrl,
    required this.from,
    required this.lastPage,
    required this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    required this.to,
    required this.total,
  });

  factory Alumni.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Alumni(
      currentPage: json['current_page'] as int? ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((i) => AlumniDetail.fromJson(i as Map<String, dynamic>? ?? {}))
          .toList(),
      firstPageUrl: json['first_page_url'] as String? ?? '',
      from: json['from'] as int? ?? 0,
      lastPage: json['last_page'] as int? ?? 0,
      lastPageUrl: json['last_page_url'] as String? ?? '',
      links: (json['links'] as List<dynamic>? ?? [])
          .map((i) => Link.fromJson(i as Map<String, dynamic>? ?? {}))
          .toList(),
      nextPageUrl: json['next_page_url'] as String?,
      path: json['path'] as String? ?? '',
      perPage: json['per_page'] as int? ?? 0,
      to: json['to'] as int? ?? 0,
      total: json['total'] as int? ?? 0,
    );
  }
}

class AlumniDetail {
  final int noInduk;
  final String nama;
  final String? noHp;
  final String? murroby;
  final String? waliKelas;
  final int? tahunLulus;
  final int? tahunMasukMi;
  final String? namaPondokMi;
  final int? tahunMasukMenengah;
  final String? namaSekolahMenengah;
  final int? tahunMasukMenengahAtas;
  final String? namaPondokMenengahAtas;
  final int? tahunMasukPerguruanTinggi;
  final String? namaPerguruanTinggi;
  final String? namaPondokPerguruanTinggi;
  final int? tahunMasukProfesi;
  final String? namaPerusahaan;
  final String? bidangProfesi;
  final String? posisiProfesi;
  final String? masaTempuh;
  final String? khotimin;

  AlumniDetail({
    required this.noInduk,
    required this.nama,
    this.noHp,
    this.murroby,
    this.waliKelas,
    this.tahunLulus,
    this.tahunMasukMi,
    this.namaPondokMi,
    this.tahunMasukMenengah,
    this.namaSekolahMenengah,
    this.tahunMasukMenengahAtas,
    this.namaPondokMenengahAtas,
    this.tahunMasukPerguruanTinggi,
    this.namaPerguruanTinggi,
    this.namaPondokPerguruanTinggi,
    this.tahunMasukProfesi,
    this.namaPerusahaan,
    this.bidangProfesi,
    this.posisiProfesi,
    this.masaTempuh,
    this.khotimin
  });

  factory AlumniDetail.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return AlumniDetail(
      noInduk: json['noInduk'] as int? ?? 0,
      nama: json['nama'] as String? ?? '',
      noHp: json['noHp'] as String?,
      murroby: json['murroby'] as String?,
      waliKelas: json['waliKelas'] as String?,
      tahunLulus: json['tahunLulus'] as int? ?? 0,
      tahunMasukMi: json['tahunMasukMi'] as int?,
      namaPondokMi: json['namaPondokMi'] as String?,
      tahunMasukMenengah: json['tahunMasukMenengah'] as int?,
      namaSekolahMenengah: json['namaSekolahMenengah'] as String?,
      tahunMasukMenengahAtas: json['tahunMasukMenengahAtas'] as int?,
      namaPondokMenengahAtas: json['namaPondokMenengahAtas'] as String?,
      tahunMasukPerguruanTinggi: json['tahunMasukPerguruanTinggi'] as int?,
      namaPerguruanTinggi: json['namaPerguruanTinggi'] as String?,
      namaPondokPerguruanTinggi: json['namaPondokPerguruanTinggi'] as String?,
      tahunMasukProfesi: json['tahunMasukProfesi'] as int?,
      namaPerusahaan: json['namaPerusahaan'] as String?,
      bidangProfesi: json['bidangProfesi'] as String?,
      posisiProfesi: json['posisiProfesi'] as String?,
      masaTempuh: json['masaTempuh'] as String?,
      khotimin: json['khotimin'] as String?,
    );
  }
}

class PerTahun {
  final int tahun;
  final List<AlumniDetail> data;

  PerTahun({
    required this.tahun,
    required this.data,
  });

  factory PerTahun.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return PerTahun(
      tahun: json['tahun'] as int? ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((i) => AlumniDetail.fromJson(i as Map<String, dynamic>? ?? {}))
          .toList(),
    );
  }
}

class Link {
  final String? url;
  final String label;
  final bool active;

  Link({
    this.url,
    required this.label,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic>? json) {
    json ??= {};
    return Link(
      url: json['url'] as String?,
      label: json['label'] as String? ?? '',
      active: json['active'] as bool? ?? false,
    );
  }
}