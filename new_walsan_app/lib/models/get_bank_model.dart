class BankResponse {
  final int status;
  final String message;
  final List<Bank> data;

  BankResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BankResponse.fromJson(Map<String, dynamic> json) {
    return BankResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List).map((i) => Bank.fromJson(i)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class Bank {
  final int id;
  final String nama;

  Bank({
    required this.id,
    required this.nama,
  });

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      id: json['id'],
      nama: json['nama'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
    };
  }
}