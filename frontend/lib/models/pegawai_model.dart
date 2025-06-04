class Pegawai {
  final String nama;
  final bool alhafidz;
  final String photoUrl;
  final String jenisKelamin;
  final String jabatan;
  final bool hasDefaultPhoto;

  Pegawai({
    required this.nama,
    required this.alhafidz,
    required this.photoUrl,
    required this.jenisKelamin,
    required this.jabatan,
    this.hasDefaultPhoto = false,
  });

  factory Pegawai.fromJson(Map<String, dynamic> json) {
    final String nama = json['nama'] ?? '';
    final photoUrl = _buildPhotoUrl(json['photo'], nama);
    return Pegawai(
      nama: nama,
      alhafidz: json['alhafidz'] == 1 || json['alhafidz'] == true,
      photoUrl: photoUrl,
      jenisKelamin: json['jenis_kelamin'] ?? '',
      jabatan: json['jabatan'] ?? '',
      hasDefaultPhoto: _isDefaultPhoto(photoUrl),
    );
  }

  static String _buildPhotoUrl(String? photoName, String nama) {
    if (photoName == null || photoName.isEmpty) {
      final initials = _getInitials(nama);
      final encodedName = Uri.encodeComponent(nama.trim());
      return "https://ui-avatars.com/api/?name=$encodedName&initials=$initials&background=0D8ABC&color=ffffff";
    }

    if (photoName.startsWith('http')) {
      return photoName;
    }

    return "https://manajemen.ppatq-rf.id/assets/img/upload/photo/$photoName";
  }

  static String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  static bool _isDefaultPhoto(String url) {
    return url.contains("ui-avatars.com");
  }

  static List<Pegawai> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Pegawai.fromJson(json)).toList();
  }
}
