// screens/form_pembayaran_screen.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../services/pembayaran_service.dart';
import '../models/pembayaran_model.dart';

class PembayaranScreen extends StatefulWidget {
  final int noInduk;
  final String namaSantri;
  final String kelas;
  final int bulan;
  final int tahun;

  PembayaranScreen({
    required this.noInduk,
    required this.namaSantri,
    required this.kelas,
    required this.bulan,
    required this.tahun,
  });

  @override
  _PembayaranScreenState createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  final _formKey = GlobalKey<FormState>();
  final PembayaranService _pembayaranService = PembayaranService();
  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _atasNamaController = TextEditingController();
  final TextEditingController _noWaController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  File? _buktiPembayaran;
  List<double> _nominalPembayaran = [0.0, 0.0, 0.0]; // Contoh: SPP, Daftar Ulang, Saku
  double _total = 0.0;

  @override
  void initState() {
    super.initState();
    _loadDataPembayaran();
  }

  Future<void> _loadDataPembayaran() async {
    try {
      final data = await _pembayaranService.getDataPembayaran(
        widget.noInduk,
        widget.bulan,
        widget.tahun,
      );
      // Proses data yang diterima dari backend
      // ...
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data pembayaran: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _buktiPembayaran = File(pickedFile.path);
      });
    }
  }

  void _hitungTotal() {
    setState(() {
      _total = _nominalPembayaran.reduce((a, b) => a + b);
    });
  }

  Future<void> _submitPembayaran() async {
    if (_formKey.currentState!.validate() && _buktiPembayaran != null) {
      final pembayaran = Pembayaran(
        namaSantri: widget.noInduk.toString(),
        noInduk: widget.noInduk,
        jumlah: _total,
        tanggalBayar: DateTime.now().toString(),
        periode: widget.bulan,
        tahun: widget.tahun,
        bankPengirim: _bankController.text,
        atasNama: _atasNamaController.text,
        noWa: _noWaController.text,
        catatan: _catatanController.text,
        bukti: _buktiPembayaran!.path,
      );

      try {
        final success = await _pembayaranService.submitPembayaran(
          pembayaran,
          [1, 2, 3], // ID jenis pembayaran (sesuaikan dengan backend)
          _nominalPembayaran,
        );

        if (success) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Pembayaran berhasil disimpan')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan pembayaran: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Harap lengkapi semua data dan unggah bukti pembayaran')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Pembayaran'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('Nama Santri', widget.namaSantri),
              _buildInfoRow('Kelas', widget.kelas),
              _buildInfoRow('No. Induk', widget.noInduk.toString()),
              _buildInfoRow('Periode Pembayaran', '${widget.bulan}/${widget.tahun}'),
              Divider(thickness: 2),
              
              // Form Jenis Pembayaran
              Text('Jenis Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buildJenisPembayaran('SPP', 0),
              _buildJenisPembayaran('Daftar Ulang', 1),
              _buildJenisPembayaran('Saku', 2),
              SizedBox(height: 16),
              
              // Total Pembayaran
              Text('Total Pembayaran: Rp ${_total.toStringAsFixed(2)}', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(thickness: 2),
              
              // Form Data Transfer
              TextFormField(
                controller: _bankController,
                decoration: InputDecoration(
                  labelText: 'Bank Pengirim',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan bank pengirim';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _atasNamaController,
                decoration: InputDecoration(
                  labelText: 'Atas Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nama pemilik rekening';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _noWaController,
                decoration: InputDecoration(
                  labelText: 'No. WhatsApp (untuk konfirmasi)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harap masukkan nomor WhatsApp';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _catatanController,
                decoration: InputDecoration(
                  labelText: 'Catatan (opsional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              
              // Upload Bukti Pembayaran
              Text('Bukti Pembayaran', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              _buktiPembayaran == null
                  ? OutlinedButton(
                      onPressed: _pickImage,
                      child: Text('Unggah Bukti Transfer'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(double.infinity, 48),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.file(_buktiPembayaran!, height: 200),
                        TextButton(
                          onPressed: _pickImage,
                          child: Text('Ganti Gambar'),
                        ),
                      ],
                    ),
              SizedBox(height: 24),
              
              // Tombol Submit
              ElevatedButton(
                onPressed: _submitPembayaran,
                child: Text('Simpan Pembayaran'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildJenisPembayaran(String label, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label),
          ),
          Expanded(
            flex: 3,
            child: TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                prefixText: 'Rp ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _nominalPembayaran[index] = double.tryParse(value) ?? 0.0;
                _hitungTotal();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bankController.dispose();
    _atasNamaController.dispose();
    _noWaController.dispose();
    _catatanController.dispose();
    super.dispose();
  }
}