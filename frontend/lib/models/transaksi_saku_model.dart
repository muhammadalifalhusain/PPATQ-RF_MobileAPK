class TransaksiSakuModel {
  final int totalMasuk;
  final int totalKeluar;

  const TransaksiSakuModel({
    required this.totalMasuk,
    required this.totalKeluar,
  });

  factory TransaksiSakuModel.fromJson(Map<String, dynamic> json) {
    return TransaksiSakuModel(
      totalMasuk: _parseInt(json['totalMasuk']),
      totalKeluar: _parseInt(json['totalKeluar']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;

    if (value is String) {
      return int.tryParse(
            value.replaceAll('.', '').replaceAll(',', ''),
          ) ??
          0;
    }

    return 0;
  }
}
