import 'package:flutter/material.dart';
import '../../services/keuangan_service.dart';
import '../../models/keuangan_model.dart'; // Pastikan untuk mengimpor model yang sesuai

class SakuKeluarScreen extends StatefulWidget {
  @override
  _SakuKeluarScreenState createState() => _SakuKeluarScreenState();
}

class _SakuKeluarScreenState extends State<SakuKeluarScreen> {
  final KeuanganService _service = KeuanganService();
  KeuanganResponse? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _service.getSakuKeluar();
      setState(() {
        _data = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Uang Keluar'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _data == null || _data!.data.dataUangKeluar == null
              ? Center(child: Text('Tidak ada data'))
              : ListView.builder(
                  itemCount: _data!.data.dataUangKeluar!.length,
                  itemBuilder: (context, index) {
                    final transaction = _data!.data.dataUangKeluar![index];
                    return ListTile(
                      title: Text(transaction.catatan),
                      subtitle: Text(transaction.tanggalTransaksi),
                      trailing: Text('Rp ${transaction.jumlahKeluar}'),
                    );
                  },
                ),
    );
  }
}