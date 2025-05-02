class LoginResponse {
  final int id;
  final String kode;
  final String kodeMurroby;
  final String nama;
  final int noInduk;
  final int status;
  final String token;

  LoginResponse({
    required this.id,
    required this.kode,
    required this.kodeMurroby,
    required this.nama,
    required this.noInduk,
    required this.status,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      id: json['id'],
      kode: json['kode'],
      kodeMurroby: json['kode_murroby'] ?? '',
      nama: json['nama'],
      noInduk: json['no_induk'],
      status: json['status'],
      token: json['token'],
    );
  }
}