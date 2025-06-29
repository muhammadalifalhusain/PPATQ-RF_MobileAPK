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
  int? _selectedBank; 
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
      List<int> jenisPembayaran = [];
      int totalJumlah = 0;

      bool adaInputTidakValid = false;

      for (int i = 0; i < _jenisPembayaran.length; i++) {
        String value = _controllers[i].text.replaceAll('.', '').trim();

        if (value.isNotEmpty) {
          final parsed = int.tryParse(value);
          if (parsed == null) {
            adaInputTidakValid = true;
            break;
          }

          idJenisPembayaran.add(_jenisPembayaran[i].id);
          jenisPembayaran.add(parsed);
          totalJumlah += parsed;
        }
      }

      if (adaInputTidakValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pastikan nominal yang anda masukkan hanya angka'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (idJenisPembayaran.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Masukkan minimal satu jenis pembayaran')),
        );
        return;
      }

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );

      try {
        final prefs = await SharedPreferences.getInstance();
        final noInduk = prefs.getInt('no_induk') ?? 0;

        if (noInduk == 0) throw Exception("No induk tidak ditemukan di SharedPreferences");

        final now = DateTime.now();
        final pembayaran = Pembayaran(
          noInduk: noInduk,
          jumlah: totalJumlah,
          tanggalBayar: _tanggalBayarController.text,
          periode: now.month,
          tahun: now.year,
          bankPengirim: _selectedBank!, 
          atasNama: _atasNamaController.text,
          noWa: _noWaController.text,
          catatan: _catatanController.text,
          idJenisPembayaran: idJenisPembayaran,
          jenisPembayaran: jenisPembayaran,
        );

        debugPrint('📤 Mengirim pembayaran:\n${pembayaran.toFormFields()}');
        await _pembayaranService.postPembayaran(pembayaran, _buktiBayar);

        Navigator.of(context).pop(); 
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Pembayaran berhasil dikirim'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop(); 

      } catch (e) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
          ),
        );
        debugPrint('❌ Error submit: $e');
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

  Widget _buildModernTextField({
  required TextEditingController controller,
  required String labelText,
  required IconData icon,
  TextInputType? keyboardType,
  String? Function(String?)? validator,
  int? maxLines,
  String? hintText,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Colors.grey.shade200),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.03),
          blurRadius: 8,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines ?? 1,
      style: TextStyle(
        color: Colors.grey.shade800,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: TextStyle(
          color: Colors.teal.shade600,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade300, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Container(
          margin: EdgeInsets.all(12),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.teal.shade50,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Colors.teal.shade600,
            size: 20,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16, 
          vertical: maxLines != null && maxLines! > 1 ? 18 : 18,
        ),
      ),
      validator: validator,
    ),
  );
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
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.teal.shade50,
                          Colors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.1),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 0,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header dengan icon dan title
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.send_rounded,
                                    color: Colors.teal.shade700,
                                    size: 24,
                                  ),
                                ),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Data Pengirim',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal.shade800,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      Text(
                                        'Masukkan informasi pengirim dengan lengkap',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            
                            SizedBox(height: 32),
                            
                            // Bank Dropdown dengan styling modern
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.grey.shade200),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: DropdownButtonFormField<int>(
                                value: _selectedBank,
                                decoration: InputDecoration(
                                  labelText: 'Bank Pengirim',
                                  labelStyle: TextStyle(
                                    color: Colors.teal.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(color: Colors.teal, width: 2),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: Container(
                                    margin: EdgeInsets.all(12),
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.teal.shade50,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.account_balance_rounded,
                                      color: Colors.teal.shade600,
                                      size: 20,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                                ),
                                isExpanded: true,
                                menuMaxHeight: 300,
                                dropdownColor: Colors.white,
                                style: TextStyle(
                                  color: Colors.grey.shade800,
                                  fontSize: 16,
                                ),
                                items: _banks.map((bank) {
                                  return DropdownMenuItem<int>(
                                    value: bank.id,
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
                            ),

                            SizedBox(height: 24),
                            
                            // Text Fields dengan styling konsisten
                            _buildModernTextField(
                              controller: _atasNamaController,
                              labelText: 'Atas Nama',
                              icon: Icons.person_outline_rounded,
                              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                            ),
                            
                            SizedBox(height: 24),
                            
                            _buildModernTextField(
                              controller: _noWaController,
                              labelText: 'No WhatsApp',
                              icon: Icons.phone_rounded,
                              keyboardType: TextInputType.phone,
                              validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
                              hintText: 'Contoh: 08123456789',
                            ),
                            
                            SizedBox(height: 24),
                            
                            _buildModernTextField(
                              controller: _catatanController,
                              labelText: 'Catatan (Opsional)',
                              icon: Icons.note_rounded,
                              maxLines: 3,
                              hintText: 'Tambahkan catatan jika diperlukan...',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 16),
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
                                  final formatted = currencyFormatter.format(intVal);

                                  _controllers[index].value = TextEditingValue(
                                    text: formatted,
                                    selection: TextSelection.collapsed(offset: formatted.length),
                                  );
                                },
                              ),
                            );
                          }).toList(),
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