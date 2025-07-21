class AgendaResponse {
  final int currentPage;
  final List<AgendaItem> data;
  final int total;
  final int lastPage;
  final String? nextPageUrl;

  AgendaResponse({
    required this.currentPage,
    required this.data,
    required this.total,
    required this.lastPage,
    required this.nextPageUrl,
  });

  factory AgendaResponse.fromJson(Map<String, dynamic> json) {
    return AgendaResponse(
      currentPage: json['current_page'] ?? 1,
      data: (json['data'] as List?)?.map((item) => AgendaItem.fromJson(item)).toList() ?? [],
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      nextPageUrl: json['next_page_url']?.toString(),
    );
  }
}

class AgendaItem {
  final String judul;
  final String tanggalMulai;
  final String tanggalSelesai;

  AgendaItem({
    required this.judul,
    required this.tanggalMulai,
    required this.tanggalSelesai,
  });

  factory AgendaItem.fromJson(Map<String, dynamic> json) {
    return AgendaItem(
      judul: (json['judul'] ?? '').toString().isEmpty ? 'Tanpa Judul' : json['judul'],
      tanggalMulai: (json['tanggal_mulai'] ?? '').toString().isEmpty ? '-' : json['tanggal_mulai'],
      tanggalSelesai: (json['tanggal_selesai'] ?? '').toString().isEmpty ? '-' : json['tanggal_selesai'],
    );
  }
}
