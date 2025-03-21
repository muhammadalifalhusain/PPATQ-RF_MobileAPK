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
    String rawThumbnail = json['thumbnail'] ?? '';

    // Cek apakah thumbnail sudah berupa URL lengkap atau masih nama file saja
    String formattedThumbnail = rawThumbnail.startsWith('http')
        ? rawThumbnail
        : "https://manajemen.ppatq-rf.id/assets/img/upload/berita/thumbnail/$rawThumbnail";

    return Berita(
      judul: json['judul'] ?? '',
      thumbnail: formattedThumbnail,
      isiBerita: json['isi_berita'] ?? '',
    );
  }
}
