import 'package:flutter/material.dart';
import '../../services/keuangan_service.dart';
import '../../models/keuangan_model.dart'; // Pastikan untuk mengimpor model yang sesuai

class SakuMasukScreen extends StatefulWidget {
  @override
  _SakuMasukScreenState createState() => _SakuMasukScreenState();
}

class _SakuMasukScreenState extends State<SakuMasukScreen> {
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
      final data = await _service.getSakuMasuk();
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
        title: Text('Uang Masuk'),
      ),
      body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : _data == null || _data!.data.dataUangMasuk == null
            ? Center(child: Text('Tidak ada data'))
            : ListView.builder(
                itemCount: _data!.data.dataUangMasuk!.length,
                itemBuilder: (context, index) {
                  final transaction = _data!.data.dataUangMasuk![index];
                  return ListTile(
                    title: Text(transaction.uangAsal),
                    subtitle: Text(transaction.tanggalTransaksi),
                    trailing: Text('Rp ${transaction.jumlahMasuk}'),
                  );
                },
              ),
    );
  }
}