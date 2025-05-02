import '../services/api_service.dart';

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
    final rawThumbnail = json['thumbnail']?.toString() ?? '';
    
    // Gunakan baseUrl yang sudah didefinisikan di ApiService
    final formattedThumbnail = rawThumbnail.startsWith('http')
        ? rawThumbnail
        : "${ApiService.fotoGaleriBaseUrl}${rawThumbnail.trim()}";

    return Berita(
      judul: json['judul']?.toString() ?? 'Judul tidak tersedia',
      thumbnail: formattedThumbnail,
      isiBerita: json['isi_berita']?.toString() ?? '',
    );
  }
}