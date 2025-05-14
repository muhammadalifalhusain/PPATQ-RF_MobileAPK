class PembayaranRequest {
  final String namaSantri;
  final int jumlah;
  final String tanggalBayar;
  final int periode;
  final int tahun;
  final String bankPengirim;
  final String atasNama;
  final String noWa;
  final String catatan;
  final List<int> jenisPembayaran;
  final List<int> idJenisPembayaran;
  final String filePath;

  PembayaranRequest({
    required this.namaSantri,
    required this.jumlah,
    required this.tanggalBayar,
    required this.periode,
    required this.tahun,
    required this.bankPengirim,
    required this.atasNama,
    required this.noWa,
    required this.catatan,
    required this.jenisPembayaran,
    required this.idJenisPembayaran,
    required this.filePath,
  });
}
