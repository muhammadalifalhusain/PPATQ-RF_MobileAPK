class DakwahResponse {
  final int status;
  final String message;
  final DakwahData data;

  DakwahResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory DakwahResponse.fromJson(Map<String, dynamic> json) {
    return DakwahResponse(
      status: json['status'],
      message: json['message'],
      data: DakwahData.fromJson(json['data']),
    );
  }
}

class DakwahData {
  final int currentPage;
  final List<DakwahItem> data;
  final String? nextPageUrl;
  final String? prevPageUrl;

  DakwahData({
    required this.currentPage,
    required this.data,
    required this.nextPageUrl,
    required this.prevPageUrl,
  });

  factory DakwahData.fromJson(Map<String, dynamic> json) {
    return DakwahData(
      currentPage: json['current_page'],
      data: List<DakwahItem>.from(
          json['data'].map((item) => DakwahItem.fromJson(item))),
      nextPageUrl: json['next_page_url'],
      prevPageUrl: json['prev_page_url'],
    );
  }
}

class DakwahItem {
  final String judul;
  final String? foto;
  final String isiDakwah;
  final String createdAt;

  DakwahItem({
    required this.judul,
    this.foto,
    required this.isiDakwah,
    required this.createdAt,
  });

  factory DakwahItem.fromJson(Map<String, dynamic> json) {
    return DakwahItem(
      judul: json['judul'],
      foto: json['foto'],
      isiDakwah: json['isiDakwah'],
      createdAt: json['createdAt'],
    );
  }
}
