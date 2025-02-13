class Santri {
  final int id;
  final String nama;
  final String kelas;
  final Employee employee;

  Santri({required this.id, required this.nama, required this.kelas, required this.employee});

  factory Santri.fromJson(Map<String, dynamic> json) {
    return Santri(
      id: json['id'],
      nama: json['nama'],
      kelas: json['kelas'],
      employee: Employee.fromJson(json['employee']),
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
