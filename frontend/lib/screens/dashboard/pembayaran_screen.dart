import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/pembayaran_model.dart';
import '../../models/get_bank_model.dart';
import '../../services/get_bank_service.dart';
import '../../services/pembayaran_service.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InputPembayaranScreen extends StatefulWidget {
  @override
  _InputPembayaranScreenState createState() => _InputPembayaranScreenState();
}

class _InputPembayaranScreenState extends State<InputPembayaranScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final PembayaranService _pembayaranService = PembayaranService();
  final BankService _bankService = BankService();
  final NumberFormat currencyFormatter = NumberFormat("#,##0", "id_ID");

  List<Bank> _banks = [];
  List<JenisPembayaran> _jenisPembayaran = [];
  List<TextEditingController> _controllers = [];
  String? _selectedBank;
  File? _buktiBayar;
  bool _isLoading = true;
  int _totalJumlah = 0;

  // Form controllers
  final TextEditingController _noIndukController = TextEditingController();
  final TextEditingController _tanggalBayarController = TextEditingController();
  final TextEditingController _periodeController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _atasNamaController = TextEditingController();
  final TextEditingController _noWaController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await Future.wait([
        _loadBanks(),
        _loadJenisPembayaran(),
      ]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadBanks() async {
    try {
      final response = await _bankService.getBanks();
      setState(() {
        _banks = response.data;
      });
    } catch (e) {
      print('Error loading banks: $e');
      throw e;
    }
  }

  Future<void> _loadJenisPembayaran() async {
    try {
      setState(() {
        _isLoading = true;
      });

      _jenisPembayaran = await _pembayaranService.getJenisPembayaran();
      
      _jenisPembayaran.sort((a, b) => a.urutan.compareTo(b.urutan));
      
      _controllers = List.generate(
        _jenisPembayaran.length, 
        (index) {
          final controller = TextEditingController();
          controller.addListener(_calculateTotal);
          return controller;
        }
      );
      
      setState(() {
        _isLoading = false;
      });
      
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat jenis pembayaran'),
          backgroundColor: Colors.red,
        ),
      );
      throw e;
    }
  }

  void _calculateTotal() {
    int total = 0;
    for (int i = 0; i < _controllers.length; i++) {
      String value = _controllers[i].text.trim();
      if (value.isNotEmpty && int.tryParse(value) != null) {
        total += int.parse(value);
      }
    }
    
    setState(() {
      _totalJumlah = total;
    });
  }

  Future<void> _pickBuktiBayar() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _buktiBayar = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }
  

  void _submit() async {
    if (_formKey.currentState!.validate()) {
        if (_buktiBayar == null) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Bukti bayar wajib diupload')),
            );
            return;
        }

        List<int> idJenisPembayaran = [];
        List<String> jenisPembayaran = [];
        int totalJumlah = 0;

        for (int i = 0; i < _jenisPembayaran.length; i++) {
            String value = _controllers[i].text.trim();
            if (value.isNotEmpty && int.tryParse(value) != null) {
                int nominal = int.parse(value);
                print('🔍 Nominal untuk jenis pembayaran ${_jenisPembayaran[i].id}: $nominal');
                totalJumlah += nominal;
                idJenisPembayaran.add(_jenisPembayaran[i].id);
                jenisPembayaran.add(value);
            }
        }

        // Memeriksa apakah idJenisPembayaran kosong setelah pengisian
        if (idJenisPembayaran.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Masukkan minimal satu jenis pembayaran')),
            );
            return;
        }

        // Tampilkan loading dialog
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => Center(child: CircularProgressIndicator()),
        );

        try {
            final prefs = await SharedPreferences.getInstance();
            final noInduk = prefs.getInt('no_induk') ?? 0;

            if (noInduk == 0) {
                throw Exception("No induk tidak ditemukan di SharedPreferences");
            }

            final now = DateTime.now();
            final int periode = now.month;
            final int tahun = now.year;

            // Validasi input sebelum membuat objek Pembayaran
            if (_tanggalBayarController.text.isEmpty) {
                throw Exception("Tanggal bayar harus diisi");
            }

            if (_selectedBank == null || _selectedBank!.isEmpty) {
                throw Exception("Bank pengirim harus dipilih");
            }

            if (_atasNamaController.text.isEmpty) {
                throw Exception("Nama pemilik rekening harus diisi");
            }

            if (_noWaController.text.isEmpty) {
                throw Exception("Nomor WhatsApp harus diisi");
            }

            print('🔍 Total Jumlah: $totalJumlah');
            print('🔍 ID Jenis Pembayaran: $idJenisPembayaran');
            print('🔍 Jenis Pembayaran: $jenisPembayaran');

            // ✅ PERBAIKAN: Kirim semua data sekaligus dalam satu request
            Pembayaran pembayaran = Pembayaran(
                noInduk: noInduk,
                jumlah: totalJumlah, // Total dari semua jenis pembayaran
                tanggalBayar: _tanggalBayarController.text,
                periode: periode,
                tahun: tahun,
                bankPengirim: _selectedBank!,
                atasNama: _atasNamaController.text,
                noWa: _noWaController.text,
                catatan: _catatanController.text,
                idJenisPembayaran: idJenisPembayaran, // ✅ Kirim semua ID sekaligus
                jenisPembayaran: jenisPembayaran, // ✅ Kirim semua nominal sekaligus
            );

            debugPrint('Data Pembayaran yang akan dikirim:');
            debugPrint(pembayaran.toFormFields().toString());

            // ✅ PERBAIKAN: Hanya satu kali panggil service
            await _pembayaranService.postPembayaran(pembayaran, _buktiBayar);

            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text('Pembayaran berhasil dikirim'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 3),
                ),
            );
            Navigator.of(context).pop();

        } catch (error) {
            Navigator.of(context).pop();

            String errorMessage = 'Gagal mengirim pembayaran';

            if (error.toString().contains('SocketException')) {
                errorMessage = 'Tidak ada koneksi internet';
            } else if (error.toString().contains('TimeoutException')) {
                errorMessage = 'Server tidak merespons, coba lagi nanti';
            } else if (error.toString().contains('FormatException')) {
                errorMessage = 'Terjadi kesalahan format data';
            } else {
                errorMessage = error.toString();
            }

            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(errorMessage),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                ),
            );

            debugPrint('Error saat mengirim pembayaran: $error');
            debugPrintStack(stackTrace: StackTrace.current);
        }
    }
}


  @override
  void dispose() {
    _noIndukController.dispose();
    _tanggalBayarController.dispose();
    _periodeController.dispose();
    _tahunController.dispose();
    _atasNamaController.dispose();
    _noWaController.dispose();
    _catatanController.dispose();
    
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        toolbarHeight: 56,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Lapor Bayar',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
    body: _isLoading
        ? Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section: Tanggal Bayar
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Pembayaran',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _tanggalBayarController,
                              decoration: InputDecoration(
                                labelText: 'Tanggal Bayar',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.calendar_today),
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.date_range),
                                  onPressed: () => _selectDate(_tanggalBayarController),
                                ),
                              ),
                              readOnly: true,
                              validator: (value) =>
                                  value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Section: Data Pengirim - PERBAIKAN DI SINI
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Data Pengirim',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: _selectedBank,
                              decoration: InputDecoration(
                                labelText: 'Bank Pengirim',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.account_balance),
                              ),
                              isExpanded: true, // Ini yang penting untuk mencegah overflow
                              menuMaxHeight: 300, // Batasi tinggi menu
                              items: _banks.map((bank) {
                                return DropdownMenuItem<String>(
                                  value: bank.id.toString(),
                                  child: Text(
                                    bank.nama,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) => setState(() => _selectedBank = value),
                              validator: (value) => value == null ? 'Wajib pilih bank' : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _atasNamaController,
                              decoration: InputDecoration(
                                labelText: 'Atas Nama',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.person_outline),
                              ),
                              validator: (value) =>
                                  value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _noWaController,
                              decoration: InputDecoration(
                                labelText: 'No WhatsApp',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.phone),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) =>
                                  value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                            SizedBox(height: 16),
                            TextFormField(
                              controller: _catatanController,
                              decoration: InputDecoration(
                                labelText: 'Catatan (Opsional)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.note),
                              ),
                              maxLines: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Section: Rincian Jenis Pembayaran
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rincian Jenis Pembayaran',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 16),
                            ..._jenisPembayaran.asMap().entries.map((entry) {
                              int index = entry.key;
                              JenisPembayaran jenis = entry.value;

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: TextFormField(
                                  controller: _controllers[index],
                                  decoration: InputDecoration(
                                    labelText: jenis.jenis,
                                    hintText: jenis.harga > 0
                                        ? currencyFormatter.format(jenis.harga)
                                        : 'Masukkan nominal',
                                    border: OutlineInputBorder(),
                                    prefixIcon: Icon(Icons.payments),
                                    prefixText: 'Rp ',
                                  ),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    String newValue = value.replaceAll('.', '');
                                    if (newValue.isEmpty) return;

                                    final intVal = int.tryParse(newValue);
                                    if (intVal == null) return;

                                    // Update text dengan format 3 digit
                                    final formatted = currencyFormatter.format(intVal);

                                    _controllers[index].value = TextEditingValue(
                                      text: formatted,
                                      selection: TextSelection.collapsed(offset: formatted.length),
                                    );

                                    // Update model atau total jika perlu
                                    // jenis.nominal = intVal;
                                  },
                                ),
                              );
                            }).toList(),

                            // Total
                            if (_totalJumlah > 0) ...[
                              Divider(thickness: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Pembayaran:',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${currencyFormatter.format(_totalJumlah)}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                    
                    // Section: Bukti Bayar
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bukti Pembayaran',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                            ),
                            SizedBox(height: 16),
                            GestureDetector(
                              onTap: _pickBuktiBayar,
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: _buktiBayar != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.file(
                                          _buktiBayar!,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.cloud_upload,
                                            size: 64,
                                            color: Colors.grey,
                                          ),
                                          SizedBox(height: 16),
                                          Text(
                                            'Tap untuk pilih bukti bayar',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ),
                            if (_buktiBayar != null) ...[
                              SizedBox(height: 8),
                              Text(
                                'Tap gambar untuk mengubah',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Kirim Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
  );
}
}