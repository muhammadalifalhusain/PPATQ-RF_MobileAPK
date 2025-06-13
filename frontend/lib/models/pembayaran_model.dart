class Pembayaran {
  final int noInduk;
  final int jumlah;
  final String tanggalBayar;
  final int periode;
  final int tahun;
  final String bankPengirim;
  final String atasNama;
  final String noWa;
  final String? catatan;
  final List<int> idJenisPembayaran; // Field baru
  final List<String> jenisPembayaran; // Field baru

  Pembayaran({
    required this.noInduk,
    required this.jumlah,
    required this.tanggalBayar,
    required this.periode,
    required this.tahun,
    required this.bankPengirim,
    required this.atasNama,
    required this.noWa,
    this.catatan,
    required this.idJenisPembayaran,
    required this.jenisPembayaran,
  });

  Map<String, dynamic> toFormFields() {
    return {
      'noInduk': noInduk.toString(),
      'jumlah': jumlah.toString(),
      'tanggalBayar': tanggalBayar,
      'periode': periode.toString(),
      'tahun': tahun.toString(),
      'bankPengirim': bankPengirim,
      'atasNama': atasNama,
      'noWa': noWa,
      'catatan': catatan ?? '',
      'idJenisPembayaran[]': idJenisPembayaran.map((id) => id.toString()).toList(),
      'jenisPembayaran[]': jenisPembayaran.map((jenis) => jenis.toString()).toList(),
    };
  }
}


class JenisPembayaranModel {
  final List<JenisPembayaran> data;

  JenisPembayaranModel({required this.data});

  factory JenisPembayaranModel.fromJson(Map<String, dynamic> json) {
    return JenisPembayaranModel(
      data: List<JenisPembayaran>.from(
        json['data'].map((item) => JenisPembayaran.fromJson(item)),
      ),
    );
  }
}

class JenisPembayaran {
  final int id;
  final String jenis;
  final int urutan;
  final int harga;

  JenisPembayaran({
    required this.id,
    required this.jenis,
    required this.urutan,
    required this.harga,
  });

  factory JenisPembayaran.fromJson(Map<String, dynamic> json) {
    return JenisPembayaran(
      id: json['id'],
      jenis: json['jenis'],
      urutan: json['urutan'],
      harga: json['harga'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jenis': jenis,
      'urutan': urutan,
      'harga': harga,
    };
  }
}
