import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'landing_page.dart';
import './dashboard/main.dart';
import '../services/login_service.dart';
import '../services/get-santri_service.dart';
import '../models/get-santri_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController kodeController = TextEditingController();
  late TextEditingController searchController;
  DateTime? selectedDate;

  final LoginService loginService = LoginService();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  List<Santri> santriList = [];
  Santri? selectedSantri;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _fetchSantri();
    
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack));

    _animationController.forward();
  }

  Future<void> _fetchSantri() async {
    try {
      final response = await SantriService.fetchAllSantri();
      setState(() {
        santriList = response.data;
      });
    } catch (e) {
      print('Gagal ambil data santri: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat data santri'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    kodeController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 10),
      firstDate: DateTime(1970),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate() || selectedSantri == null || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Harap isi semua data dengan benar."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final tanggalLahirFormatted = DateFormat('yyyy-MM-dd').format(selectedDate!);

      print('Login attempt - noInduk: ${selectedSantri!.noInduk}, kode: ${kodeController.text.trim()}, tanggalLahir: $tanggalLahirFormatted');

      final response = await loginService.loginSiswa(
        noInduk: selectedSantri!.noInduk,
        kode: kodeController.text.trim(),
        tanggalLahir: tanggalLahirFormatted,
      );

      print('Login successful: $response');

      // Simpan data login ke SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('no_induk', response.noInduk.toString());
      await prefs.setString('kode', response.kode);
      await prefs.setString('nama', response.nama);
      await prefs.setBool('is_logged_in', true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text('Login berhasil! Selamat datang')),
            ],
          ),
          backgroundColor: Colors.green,
        ),
      );

      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    } catch (e) {
      print('Login error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Expanded(child: Text(e.toString().replaceAll('Exception: ', ''))),
            ],
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00695C), Color(0xFF004D40), Color(0xFF00251A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LandingPage()),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Image.asset('assets/images/logo.png', height: 80, width: 80),
                            SizedBox(height: 24),
                            Text('Selamat Datang', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 8),
                            Text('PPATQ RAUDLATUL FALAH', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
                            SizedBox(height: 40),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Autocomplete<Santri>(
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text.isEmpty) {
                                        return const Iterable<Santri>.empty();
                                      }
                                      return santriList.where((santri) =>
                                        santri.nama.toLowerCase().contains(textEditingValue.text.toLowerCase()) ||
                                        (santri.noInduk.toLowerCase().contains(textEditingValue.text.toLowerCase())));
                                    },
                                    displayStringForOption: (Santri santri) => '${santri.nama} (${santri.noInduk})',
                                    onSelected: (Santri selection) {
                                      setState(() {
                                        selectedSantri = selection;
                                        searchController.text = '${selection.nama} (${selection.noInduk})';
                                      });
                                    },
                                    optionsViewBuilder: (context, onSelected, options) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Material(
                                          elevation: 4.0,
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.9,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: ListView.builder(
                                              padding: EdgeInsets.zero,
                                              shrinkWrap: true,
                                              itemCount: options.length,
                                              itemBuilder: (BuildContext context, int index) {
                                                final Santri option = options.elementAt(index);
                                                return ListTile(
                                                  title: Text(option.nama),
                                                  subtitle: Text('No. Induk: ${option.noInduk}'),
                                                  onTap: () {
                                                    onSelected(option);
                                                  },
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                                      return TextFormField(
                                        controller: controller,
                                        focusNode: focusNode,
                                        onEditingComplete: onEditingComplete,
                                        style: TextStyle(color: Colors.white),
                                        decoration: InputDecoration(
                                          labelText: 'Cari Nama Santri',
                                          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                                          prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.1),
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                                          ),
                                        ),
                                        validator: (_) => selectedSantri == null ? 'Pilih nama santri' : null,
                                      );
                                    },
                                  ),
                                  if (selectedSantri != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "No. Induk: ${selectedSantri!.noInduk}",
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ),
                                  SizedBox(height: 20),
                                  _buildTextField(
                                    controller: kodeController,
                                    label: 'Kelas',
                                    icon: Icons.qr_code_2,
                                    validator: (value) => value?.isEmpty ?? true ? 'Kelas harus diisi' : null,
                                  ),
                                  SizedBox(height: 20),
                                  _buildDatePicker(context),
                                  SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Color(0xFF00695C),
                                        elevation: 8,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                      ),
                                      child: isLoading
                                          ? SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00695C)),
                                              ),
                                            )
                                          : Text('Masuk', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('PPATQ RAUDLATUL FALAH', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8))),
                    SizedBox(height: 4),
                    Text('Copyright © 2025 All Rights Reserved', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.8)),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: _pickDate,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.white.withOpacity(0.8)),
            SizedBox(width: 12),
            Text(
              selectedDate == null
                  ? 'Pilih Tanggal Lahir'
                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
          ],
        ),
      ),
    );
  }
}