class SaldoSakuModel {
  final int value;

  const SaldoSakuModel({required this.value});

  factory SaldoSakuModel.fromJson(Map<String, dynamic> json) {
    return SaldoSakuModel(
      value: _parseInt(json['data']),
    );
  }

  static int _parseInt(dynamic raw) {
    if (raw == null) return 0;
    if (raw is int) return raw;

    if (raw is String) {
      return int.tryParse(
            raw.replaceAll('.', '').replaceAll(',', ''),
          ) ??
          0;
    }

    return 0;
  }
}
