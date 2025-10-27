import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../models/pembayaran_model.dart';
import '../../models/get_bank_model.dart';
import '../../services/get_bank_service.dart';
import '../../services/pembayaran_service.dart';
import '../../widgets/tanggal_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


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
  bool _isNominalSesuai = false;
  String _validationMessage = '';
  String _selectedMetode = 'transfer';
  int _totalJumlah = 0;
  String? tanggalBayar;
  
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _noIndukController = TextEditingController();
  final TextEditingController _periodeController = TextEditingController();
  final TextEditingController _tahunController = TextEditingController();
  final TextEditingController _atasNamaController = TextEditingController();
  final TextEditingController _noWaController = TextEditingController();
  final TextEditingController _catatanController = TextEditingController();
  final TextEditingController _nominalTransferController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _nominalTransferController.addListener(_cekKecocokanNominal);
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

  void _cekKecocokanNominal() {
    final input = _nominalTransferController.text.replaceAll('.', '').replaceAll(',', '');
    final nominalTransfer = int.tryParse(input) ?? 0;
    
    setState(() {
      _isNominalSesuai = nominalTransfer == _totalJumlah;
    });
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
      String value = _controllers[i].text
          .replaceAll('.', '')
          .replaceAll('Rp', '')
          .replaceAll(',', '')
          .replaceAll(' ', '');

      if (value.isNotEmpty && int.tryParse(value) != null) {
        total += int.parse(value);
      }
    }

    setState(() {
      _totalJumlah = total;
    });

    _cekKecocokanNominal();
  }
  
  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
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

      if (_nominalTransferController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Total transfer wajib diisi')),
        );
        return;
      }

      final nominalTransfer = int.tryParse(
        _nominalTransferController.text.replaceAll('.', '').replaceAll(',', '')
      ) ?? 0;

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

      if (!_isNominalSesuai) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Total transfer tidak sesuai dengan rincian pembayaran'),
            backgroundColor: Colors.red,
          ),
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
        final noInduk = prefs.getInt('noInduk') ?? 0;

        if (noInduk == 0) throw Exception("No induk tidak ditemukan di SharedPreferences");

        final now = DateTime.now();
        final pembayaran = Pembayaran(
          noInduk: noInduk,
          jumlah: totalJumlah,
          tanggalBayar: tanggalBayar!,
          periode: now.month,
          tahun: now.year,
          bankPengirim: _selectedMetode == 'transfer' ? _selectedBank! : 0,
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

        String errorMessage = 'Gagal mengirim pembayaran';
        final errorString = e.toString();
        final jsonStart = errorString.indexOf('{');
        final jsonEnd = errorString.lastIndexOf('}');

        if (jsonStart != -1 && jsonEnd != -1) {
          try {
            final jsonStr = errorString.substring(jsonStart, jsonEnd + 1);
            final Map<String, dynamic> json = jsonDecode(jsonStr);
            if (json.containsKey('message')) {
              errorMessage = json['message'];
            }
          } catch (_) {}
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _noIndukController.dispose();
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
    String? hintText,
    int? maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
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
        maxLines: maxLines,
        validator: validator,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.grey.shade800,
          height: 1.4,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.poppins(
            color: Colors.teal.shade600,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(
            color: Colors.grey.shade400,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red.shade400, width: 1),
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
            horizontal: 14,
            vertical: maxLines != null && maxLines > 1 ? 16 : 20,
          ),
          errorStyle: GoogleFonts.poppins(
            color: Colors.red.shade600,
            fontSize: 12,
            height: 1.2,
          ),
        ),
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
                  TanggalPembayaranDropdown(
                    onDateChanged: (value) {
                      setState(() {
                        tanggalBayar = value;
                      });
                    },
                  ),
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
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Data Pengirim',
                                        style: GoogleFonts.poppins(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.teal.shade800,
                                          letterSpacing: 0.5,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Masukkan informasi pengirim dengan lengkap',
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.grey.shade600,
                                          fontWeight: FontWeight.w400,
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            IntrinsicHeight(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.03),
                                          blurRadius: 8,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedMetode,
                                      decoration: InputDecoration(
                                        labelText: 'Metode Pembayaran',
                                        labelStyle: GoogleFonts.poppins(
                                          color: Colors.teal.shade600,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        hintText: 'Pilih metode pembayaran',
                                        hintStyle: GoogleFonts.poppins(
                                          color: Colors.grey.shade400,
                                          fontSize: 14,
                                        ),
                                        border: OutlineInputBorder(
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
                                            Icons.payment_rounded,
                                            color: Colors.teal.shade600,
                                            size: 20,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                      ),
                                      isExpanded: true,
                                      menuMaxHeight: 250,
                                      dropdownColor: Colors.white,
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey.shade800,
                                        fontSize: 16,
                                      ),
                                      items: [
                                        DropdownMenuItem(
                                          value: 'transfer',
                                          child: Text('Transfer Bank', style: GoogleFonts.poppins()),
                                        ),
                                        DropdownMenuItem(
                                          value: 'cash',
                                          child: Text('Cash', style: GoogleFonts.poppins()),
                                        ),
                                        DropdownMenuItem(
                                          value: 'va',
                                          child: Text('Virtual Account', style: GoogleFonts.poppins()),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedMetode = value!;
                                          if (_selectedMetode != 'transfer') {
                                            _selectedBank = 0;
                                          }
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Pilih metode pembayaran';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    height: _selectedMetode == 'transfer' ? null : 0,
                                    child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 300),
                                      opacity: _selectedMetode == 'transfer' ? 1.0 : 0.0,
                                      child: _selectedMetode == 'transfer'
                                          ? Container(
                                              margin: EdgeInsets.only(bottom: 16),
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
                                                  labelStyle: GoogleFonts.poppins(
                                                    color: Colors.teal.shade600,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  hintText: 'Pilih bank pengirim',
                                                  hintStyle: GoogleFonts.poppins(
                                                    color: Colors.grey.shade400,
                                                    fontSize: 14,
                                                  ),
                                                  border: OutlineInputBorder(
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
                                                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                                                ),
                                                isExpanded: true,
                                                menuMaxHeight: 300,
                                                dropdownColor: Colors.white,
                                                style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 16,
                                                ),
                                                items: _banks.map<DropdownMenuItem<int>>((bank) {
                                                  return DropdownMenuItem<int>(
                                                    value: bank.id,
                                                    child: Text(
                                                      bank.nama,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 1,
                                                      style: GoogleFonts.poppins(fontSize: 14),
                                                    ),
                                                  );
                                                }).toList(),
                                                onChanged: (value) => setState(() => _selectedBank = value),
                                                validator: (value) {
                                                  if (_selectedMetode == 'transfer' && (value == null || value == 0)) {
                                                    return 'Pilih bank pengirim';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            )
                                          : SizedBox.shrink(),
                                    ),
                                  ),
                                  _buildModernTextField(
                                    controller: _atasNamaController,
                                    labelText: 'Atas Nama',
                                    icon: Icons.person_outline_rounded,
                                    validator: (value) => value?.isEmpty == true ? 'Nama wajib diisi' : null,
                                    hintText: 'Masukkan nama lengkap',
                                  ),
                                  SizedBox(height: 16),
                                  _buildModernTextField(
                                    controller: _noWaController,
                                    labelText: 'No WhatsApp',
                                    icon: Icons.phone_rounded,
                                    keyboardType: TextInputType.phone,
                                    validator: (value) {
                                      if (value?.isEmpty == true) return 'Nomor WhatsApp wajib diisi';
                                      if (!RegExp(r'^(\+?62|0)[0-9]{9,13}$').hasMatch(value!)) {
                                        return 'Format nomor tidak valid';
                                      }
                                      return null;
                                    },
                                    hintText: 'Contoh: 08123456789',
                                  ),
                                  SizedBox(height: 10),
                                  _buildModernTextField(
                                    controller: _catatanController,
                                    labelText: 'Catatan (Opsional)',
                                    icon: Icons.note_rounded,
                                    maxLines: 3,
                                    hintText: 'Tambahkan catatan jika diperlukan...',
                                    validator: null,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ),
                  SizedBox(height: 10),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Transfer',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 8),
                          TextFormField(
                            controller: _nominalTransferController,
                              style: GoogleFonts.poppins(), 
                              decoration: InputDecoration(
                                labelText: 'Masukkan nominal transfer',
                                labelStyle: GoogleFonts.poppins(fontSize: 14),
                                hintStyle: GoogleFonts.poppins(color: Colors.grey),
                                prefixText: 'Rp ',
                                prefixStyle: GoogleFonts.poppins(),
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.payment),
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              String newValue = value.replaceAll('.', '');
                              if (newValue.isEmpty) return;

                              final intVal = int.tryParse(newValue);
                              if (intVal == null) return;
                              final formatted = currencyFormatter.format(intVal);

                              _nominalTransferController.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(offset: formatted.length),
                              );
                            },
                            validator: (value) {
                              if (value!.isEmpty) return 'Wajib diisi';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                  ),          
                  SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rincian Jenis Pembayaran',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 10),
                          ..._jenisPembayaran.asMap().entries.map((entry) {
                            int index = entry.key;
                            JenisPembayaran jenis = entry.value;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: TextFormField(
                                controller: _controllers[index],
                                style: GoogleFonts.poppins(), 
                                decoration: InputDecoration(
                                  labelText: jenis.jenis,
                                  labelStyle: GoogleFonts.poppins(fontSize: 14),
                                  hintText: jenis.harga > 0
                                      ? (jenis.id == 5
                                          ? '${currencyFormatter.format(jenis.harga)} (Kecuali kelas 6)'
                                          : currencyFormatter.format(jenis.harga))
                                      : 'Masukkan nominal',
                                  hintStyle: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.payments),
                                  prefixText: 'Rp ',
                                  prefixStyle: GoogleFonts.poppins(),
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
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Rp ${currencyFormatter.format(_totalJumlah)}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: _isNominalSesuai ? Colors.green : Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            if (_nominalTransferController.text.isNotEmpty && !_isNominalSesuai)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Total rincian tidak sama dengan total lapor bayar / transfer '
                                  '(Rp ${currencyFormatter.format(int.tryParse(_nominalTransferController.text.replaceAll('.', '')) ?? 0)})',
                                  style: GoogleFonts.poppins(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bukti Pembayaran',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          SizedBox(height: 8),
                          if (_buktiBayar != null)
                            Column(
                              children: [
                                Image.file(_buktiBayar!, height: 150, fit: BoxFit.cover),
                                TextButton.icon(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  label: const Text('Hapus Gambar'),
                                  onPressed: () => setState(() => _buktiBayar = null),
                                ),
                              ],
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () => _pickImage(ImageSource.gallery),
                                  icon: const Icon(Icons.photo_library, color: Colors.black),
                                  label: Text(
                                    'Galeri',
                                    style: GoogleFonts.poppins(color: Colors.black),
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: () => _pickImage(ImageSource.camera),
                                  icon: const Icon(Icons.camera_alt, color: Colors.black),
                                  label: Text(
                                    'Kamera',
                                    style: GoogleFonts.poppins(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
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
                        'Kirim Konfirmasi Pembayaran',
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