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
      status: json['status'],
      message: json['message'],
      data: BeritaData.fromJson(json['data']),
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
      currentPage: json['current_page'],
      data: List<BeritaItem>.from(json['data'].map((x) => BeritaItem.fromJson(x))),
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
      total: json['total'],
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
    // Bersihkan path lokal jika ada
    String thumb = json['thumbnail'];
    if (thumb.startsWith('file:///')) {
      thumb = thumb.split('/').last;
    }

    String gambar = json['gambar_dalam'];
    if (gambar.startsWith('file:///')) {
      gambar = gambar.split('/').last;
    }

    return BeritaItem(
      judul: json['judul'],
      thumbnail: thumb,
      gambarDalam: gambar,
      isiBerita: json['isi_berita'],
    );
  }
}

