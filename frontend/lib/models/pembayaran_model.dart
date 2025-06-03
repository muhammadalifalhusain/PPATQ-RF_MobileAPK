class Pembayaran {
  final int id;
  final String namaSantri;
  final int jumlah;
  final String tanggalBayar;
  final String periode;
  final String tahun;
  final String bankPengirim;
  final String atasNama;
  final String noWa;
  final String? catatan;
  final String? bukti;

  Pembayaran({
    required this.id,
    required this.namaSantri,
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

  factory Pembayaran.fromJson(Map<String, dynamic> json) {
    return Pembayaran(
      id: json['id'],
      namaSantri: json['nama_santri'],
      jumlah: json['jumlah'],
      tanggalBayar: json['tanggal_bayar'],
      periode: json['periode'].toString(),
      tahun: json['tahun'].toString(),
      bankPengirim: json['bank_pengirim'],
      atasNama: json['atas_nama'],
      noWa: json['no_wa'],
      catatan: json['catatan'],
      bukti: json['bukti'],
    );
  }
}
