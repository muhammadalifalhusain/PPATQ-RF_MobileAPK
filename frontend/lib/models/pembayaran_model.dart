// models/pembayaran_model.dart
class Pembayaran {
  final String namaSantri;
  final int noInduk;
  final double jumlah;
  final String tanggalBayar;
  final int periode;
  final int tahun;
  final String bankPengirim;
  final String atasNama;
  final String noWa;
  final String? catatan;
  final String? bukti;

  Pembayaran({
    required this.namaSantri,
    required this.noInduk,
    required this.jumlah,
    required this.tanggalBayar,
    required this.periode,
    required this.tahun,
    required this.bankPengirim,
    required this.atasNama,
    required this.noWa,
    this.catatan,
    this.bukti,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_santri': namaSantri,
      'no_induk': noInduk,
      'jumlah': jumlah,
      'tanggal_bayar': tanggalBayar,
      'periode': periode,
      'tahun': tahun,
      'bank_pengirim': bankPengirim,
      'atas_nama': atasNama,
      'no_wa': noWa,
      'catatan': catatan,
    };
  }
}