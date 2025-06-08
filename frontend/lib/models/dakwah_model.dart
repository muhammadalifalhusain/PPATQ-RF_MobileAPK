class Dakwah {
  final String judul;
  final String isiDakwah;
  final String createdAt;

  Dakwah({
    required this.judul,
    required this.isiDakwah,
    required this.createdAt,
  });

  factory Dakwah.fromJson(Map<String, dynamic> json) {
    return Dakwah(
      judul: json['judul'] ?? '',
      isiDakwah: json['isi_dakwah'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class DakwahResponse {
  final int currentPage;
  final List<Dakwah> dakwahList;
  final int total;
  final int perPage;
  final int lastPage;

  DakwahResponse({
    required this.currentPage,
    required this.dakwahList,
    required this.total,
    required this.perPage,
    required this.lastPage,
  });

  factory DakwahResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return DakwahResponse(
      currentPage: data['current_page'],
      total: data['total'],
      perPage: data['per_page'],
      lastPage: data['last_page'],
      dakwahList: List<Dakwah>.from(
        data['data'].map((item) => Dakwah.fromJson(item)),
      ),
    );
  }
}
