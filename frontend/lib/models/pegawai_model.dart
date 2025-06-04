class Pegawai {
  final String nama;
  final bool alhafidz;
  final String photoUrl;
  final String jenisKelamin;
  final String jabatan;

  Pegawai({
    required this.nama,
    required this.alhafidz,
    required this.photoUrl,
    required this.jenisKelamin,
    required this.jabatan,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    return Pegawai(
      nama: json['nama'] ?? '',
      alhafidz: json['alhafidz'] == 1 || json['alhafidz'] == true,
      photoUrl: _buildPhotoUrl(json['photo']),
      jenisKelamin: json['jenis_kelamin'] ?? '',
      jabatan: json['jabatan'] ?? '',
    );
  }

  static String _buildPhotoUrl(String? photoName) {
    if (photoName == null || photoName.isEmpty) {
      return "https://manajemen.ppatq-rf.id/assets/img/upload/photo/default.png";
    }
    return "https://manajemen.ppatq-rf.id/assets/img/upload/photo/$photoName";
  }

  /// Optional: helper untuk konversi List JSON
  static List<Pegawai> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Pegawai.fromJson(json)).toList();
  }
}
