class Santri {
  final int id;
  final String nama;
  final String kelas;
  final String photo;
  final Murroby murroby;
  final Employee employee;

  Santri({
    required this.id,
    required this.nama,
    required this.kelas,
    required this.photo,
    required this.murroby,
    required this.employee,
  });

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      id: json['id'],
      nama: json['nama'],
      kelas: json['kelas'],
      photo: "https://manajemen.ppatq-rf.id/assets/img/upload/photo/${json['photo']}",
      murroby: Murroby.fromJson(json['murroby']),
      employee: Employee.fromJson(json['employee']),
    );
  }
}

class Murroby {
  final String nama;
  final String photoUrl;

  Murroby({required this.nama, required this.photoUrl});

  factory Murroby.fromJson(Map<String, dynamic> json) {
    return Murroby(
      nama: json['nama'],
      photoUrl: "https://manajemen.ppatq-rf.id/assets/img/upload/photo/${json['photo']}",
    );
  }
}

class Employee {
  final int id;
  final String nama;
  final String photoUrl;

  Employee({required this.id, required this.nama, required this.photoUrl});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      nama: json['nama'],
      photoUrl: "https://manajemen.ppatq-rf.id/assets/img/upload/photo/${json['photo']}",
    );
  }
}
