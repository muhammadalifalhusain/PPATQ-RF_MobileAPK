class LoginResponse {
  final int noInduk;
  final String kode;
  final String nama;

  LoginResponse({
    required this.noInduk,
    required this.kode,
    required this.nama,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      noInduk: json['noInduk'] is int 
          ? json['noInduk'] 
          : int.parse(json['noInduk'].toString()),  // Handle both int and string
      kode: json['kode'].toString(),
      nama: json['nama'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'noInduk': noInduk,
      'kode': kode,
      'nama': nama,
    };
  }

  @override
  String toString() {
    return 'LoginResponse{noInduk: $noInduk, kode: $kode, nama: $nama}';
  }
}