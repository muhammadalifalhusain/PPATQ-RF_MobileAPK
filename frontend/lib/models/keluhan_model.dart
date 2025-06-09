class Keluhan {
  final String namaPelapor;
  final String email;
  final String noHp;
  final int? idSantri; // ubah ke int?
  final String namaWaliSantri;
  final int? idKategori; // juga int?
  final String masukan;
  final String saran;
  final int rating;
  final String jenis;

  Keluhan({
    required this.namaPelapor,
    required this.email,
    required this.noHp,
    this.idSantri,
    required this.namaWaliSantri,
    this.idKategori,
    required this.masukan,
    required this.saran,
    required this.rating,
    required this.jenis,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama_pelapor': namaPelapor,
      'email': email,
      'no_hp': noHp,
      'id_santri': idSantri, // int or null
      'nama_wali_santri': namaWaliSantri,
      'id_kategori': idKategori,
      'masukan': masukan,
      'saran': saran,
      'rating': rating,
      'jenis': jenis,
    };
  }
}
