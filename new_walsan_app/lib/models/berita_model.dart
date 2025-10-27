class BeritaResponse {
  final int status;
  final String message;
  final BeritaData data;

  BeritaResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BeritaResponse.fromJson(Map<String, dynamic> json) {
    return BeritaResponse(
      status: json['status'] ?? 0,
      message: json['message'] ?? 'Tidak ada pesan',
      data: BeritaData.fromJson(json['data'] ?? {}),
    );
  }
}

class BeritaData {
  final int currentPage;
  final List<BeritaItem> data;
  final String? nextPageUrl;
  final String? prevPageUrl;
  final int total;

  BeritaData({
    required this.currentPage,
    required this.data,
    this.nextPageUrl,
    this.prevPageUrl,
    required this.total,
  });

  factory BeritaData.fromJson(Map<String, dynamic> json) {
    return BeritaData(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List?)
              ?.map((x) => BeritaItem.fromJson(x ?? {}))
              .toList() ??
          [],
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      total: json['total'] ?? 0,
    );
  }
}

class BeritaItem {
  final String judul;
  final String thumbnail;
  final String gambarDalam;
  final String isiBerita;

  BeritaItem({
    required this.judul,
    required this.thumbnail,
    required this.gambarDalam,
    required this.isiBerita,
  });

  factory BeritaItem.fromJson(Map<String, dynamic> json) {
    String rawThumb = (json['thumbnail'] ?? '').toString();
    String rawGambar = (json['gambar_dalam'] ?? '').toString();

    String thumb = rawThumb.startsWith('file:///')
        ? rawThumb.split('/').last
        : rawThumb;

    String gambar = rawGambar.startsWith('file:///')
        ? rawGambar.split('/').last
        : rawGambar;

    return BeritaItem(
      judul: (json['judul'] ?? 'Tanpa Judul').toString(),
      thumbnail: thumb.isNotEmpty ? thumb : 'default_thumb.jpg',
      gambarDalam: gambar.isNotEmpty ? gambar : 'default_gambar.jpg',
      isiBerita: (json['isi_berita'] ?? 'Belum ada isi berita.').toString(),
    );
  }
}

