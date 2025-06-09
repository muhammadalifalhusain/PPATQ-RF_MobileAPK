class Ustad {
  final int idUser;
  final String namaUstad;
  final String? photo;

  Ustad({
    required this.idUser,
    required this.namaUstad,
    this.photo,
  });

  factory Ustad.fromJson(Map<String, dynamic> json) {
    return Ustad(
      idUser: json['idUser'],
      namaUstad: json['namaUstad'],
      photo: json['photo'],
    );
  }
}
