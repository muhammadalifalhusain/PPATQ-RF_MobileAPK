class Galeri {
  final String nama;
  final String deskripsi;
  final String foto;

  Galeri({
    required this.nama,
    required this.deskripsi,
    required this.foto,
  });

  factory Galeri.fromJson(Map<String, dynamic> json) {
    String rawFoto = json['foto'] ?? ''; 
    String formattedFoto = rawFoto.startsWith('http')
        ? rawFoto
        : "https://manajemen.ppatq-rf.id/assets/img/upload/foto_galeri/$rawFoto";

    return Galeri(
      nama: json['nama'] ?? 'Tanpa Nama',
      deskripsi: json['deskripsi'] ?? 'Tanpa Deskripsi',
      foto: formattedFoto,
    );
  }
}
