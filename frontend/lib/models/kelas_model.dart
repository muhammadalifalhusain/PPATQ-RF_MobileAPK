class Kelas {
  final String code;
  final String name;

  Kelas({required this.code, required this.name});

  factory Kelas.fromJson(Map<String, dynamic> json) {
    return Kelas(
      code: json['code'],
      name: json['name'],
    );
  }
}
