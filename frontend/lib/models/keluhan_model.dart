class Keluhan {
  final String namaPelapor;
  final String email;
  final String noHp;
  final String idSantri;
  final String namaWaliSantri;
  final String idKategori;
  final String masukan;
  final String saran;
  final int rating;
  final String jenis;

  Keluhan({
    required this.namaPelapor,
    required this.email,
    required this.noHp,
    required this.idSantri,
    required this.namaWaliSantri,
    required this.idKategori,
    required this.masukan,
    required this.saran,
    required this.rating,
    required this.jenis,
  });

  Map<String, dynamic> toJson() {
    return {
      'namaPelapor': namaPelapor,
      'email': email,
      'noHp': noHp,
      'namaSantri': idSantri,
      'namaWaliSantri': namaWaliSantri,
      'kategori': idKategori,
      'masukan': masukan,
      'saran': saran,
      'rating': rating,
      'jenis': jenis,
    };
  }
}
