class LoginResponse {
  final int noInduk;
  final String kode;

  LoginResponse({
    required this.noInduk,
    required this.kode,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      noInduk: json['noInduk'],   // note: json key menggunakan camelCase
      kode: json['kode'],
    );
  }
}
