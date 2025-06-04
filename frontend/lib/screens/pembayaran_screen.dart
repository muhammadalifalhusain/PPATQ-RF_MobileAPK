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
  List<double> _nominalPembayaran = [0.0, 0.0, 0.0];
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
          [1, 2, 3],
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
        title: Text(
          'Form Pembayaran',
          style: TextStyle(
            color: Colors.white, // Ubah warna teks menjadi putih
          ),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.teal[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildInfoRow('Nama Santri', widget.namaSantri, Icons.person),
                      _buildInfoRow('Kelas', widget.kelas, Icons.school),
                      _buildInfoRow('No. Induk', widget.noInduk.toString(), Icons.confirmation_number),
                      _buildInfoRow('Periode', '${_getNamaBulan(widget.bulan)} ${widget.tahun}', Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Jenis Pembayaran Section
              _buildSectionHeader('Jenis Pembayaran', Icons.payment),
              SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildJenisPembayaran('SPP', 0, Icons.money),
                      Divider(height: 24),
                      _buildJenisPembayaran('Daftar Ulang', 1, Icons.edit),
                      Divider(height: 24),
                      _buildJenisPembayaran('Saku', 2, Icons.wallet),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              
              // Total Pembayaran
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Pembayaran:', 
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Rp ${_total.toStringAsFixed(2)}', 
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
                  ],
                ),
              ),
              SizedBox(height: 24),
              
              // Data Transfer Section
              _buildSectionHeader('Data Transfer', Icons.account_balance),
              SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildTextField(_bankController, 'Bank Pengirim', Icons.account_balance),
                      SizedBox(height: 16),
                      _buildTextField(_atasNamaController, 'Atas Nama', Icons.person_outline),
                      SizedBox(height: 16),
                      _buildTextField(_noWaController, 'No. WhatsApp', Icons.phone, 
                          keyboardType: TextInputType.phone),
                      SizedBox(height: 16),
                      _buildTextField(_catatanController, 'Catatan (opsional)', Icons.note, 
                          maxLines: 3),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              
              // Upload Bukti Section
              _buildSectionHeader('Bukti Pembayaran', Icons.photo_camera),
              SizedBox(height: 12),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Unggah foto bukti transfer',
                          style: TextStyle(color: Colors.grey[600])),
                      SizedBox(height: 12),
                      _buktiPembayaran == null
                          ? ElevatedButton.icon(
                              onPressed: _pickImage,
                              icon: Icon(Icons.upload_file),
                              label: Text('Pilih File'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal[100],
                                foregroundColor: Colors.teal[800],
                                minimumSize: Size(double.infinity, 48),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(_buktiPembayaran!, 
                                      height: 200,
                                      width: double.infinity,
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(height: 12),
                                OutlinedButton.icon(
                                  onPressed: _pickImage,
                                  icon: Icon(Icons.change_circle),
                                  label: Text('Ganti Gambar'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.teal,
                                    minimumSize: Size(double.infinity, 48),
                                  ),
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 32),
              
              // Submit Button
              ElevatedButton(
                onPressed: _submitPembayaran,
                child: Text('KONFIRMASI PEMBAYARAN',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.teal),
        SizedBox(width: 8),
        Text(title,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal)),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: TextStyle(fontSize: 15)),
          ),
        ],
      ),
    );
  }

  Widget _buildJenisPembayaran(String label, int index, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Colors.teal),
        SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(label, style: TextStyle(fontSize: 15)),
        ),
        Expanded(
          flex: 3,
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              prefixText: 'Rp ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            ),
            onChanged: (value) {
              _nominalPembayaran[index] = double.tryParse(value) ?? 0.0;
              _hitungTotal();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.teal),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if ((label != 'Catatan (opsional)') && (value == null || value.isEmpty)) {
          return 'Harap isi $label';
        }
        return null;
      },
    );
  }

  String _getNamaBulan(int bulan) {
    final bulanList = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return bulanList[bulan - 1];
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