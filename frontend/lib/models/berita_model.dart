class Berita {
  final String judul;
  final String thumbnail;
  final String isiBerita;

  Berita({
    required this.judul,
    required this.thumbnail,
    required this.isiBerita,
  });

  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      judul: json['judul'] ?? '', 
      thumbnail: "https://manajemen.ppatq-rf.id/assets/img/upload/berita/thumbnail/${json['thumbnail'] ?? ''}", 
      isiBerita: json['isi_berita'] ?? '',
    );
  }
}
