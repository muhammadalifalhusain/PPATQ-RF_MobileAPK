import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import 'landing_page.dart';
import './dashboard/main.dart';
import '../services/get-santri_service.dart';
import '../models/get-santri_model.dart';
import '../models/kelas_model.dart';
import '../services/get-kelas_service.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final TextEditingController kodeController = TextEditingController();
  late TextEditingController searchController;
  DateTime? selectedDate;

  final _formKey = GlobalKey<FormState>();
  List<Santri> santriList = [];
  Santri? selectedSantri;

  List<Kelas> _kelasList = [];
  String? _selectedKodeKelas;

  bool _isLoadingKelas = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    _fetchSantri();
    
    _loadKelasData();
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

  Future<void> _loadKelasData() async {
    setState(() => _isLoadingKelas = true);
    try {
      _kelasList = await KelasService.fetchKelas();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat kelas: $e')),
      );
    } finally {
      setState(() => _isLoadingKelas = false);
    }
  }

  Future<void> _fetchSantri() async {
    try {
      final response = await SantriService.fetchAllSantri();
      setState(() {
        santriList = response.data;
      });
    } catch (e) {
      _showError('Gagal memuat data santri');
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
      setState(() => selectedDate = picked);
    }
  }

  Future<void> _login(AuthProvider auth) async {
    if (!_formKey.currentState!.validate() || selectedSantri == null || selectedDate == null || _selectedKodeKelas == null) {
      _showError('Harap isi semua data dengan benar');
      return;
    }

    try {
      final tanggalLahirFormatted = DateFormat('yyyy-MM-dd').format(selectedDate!);
      
      final noInduk = int.parse(selectedSantri!.noInduk); 

      final success = await auth.login(
        noInduk: noInduk,
        kode: _selectedKodeKelas!, 
        tanggalLahir: tanggalLahirFormatted,
      );

      if (success) {
        _showSuccess('Login berhasil! Selamat datang');
        await Future.delayed(Duration(milliseconds: 500));
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => MainScreen(),
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      }
    } catch (e) {
    final message = e.toString().replaceFirst('Exception: ', '');
    _showError(message);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

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
                          MaterialPageRoute(builder: (_) => LandingPage()),
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
                            Text('Selamat Datang', 
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                            SizedBox(height: 8),
                            Text('PPATQ RAUDLATUL FALAH', 
                                style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.8))),
                            SizedBox(height: 40),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  _buildSantriSearch(),
                                    
                                  SizedBox(height: 20),
                                  _buildDropdownKelas(),
                                  SizedBox(height: 5),
                                  _buildDatePicker(),
                                  SizedBox(height: 24),
                                  _buildLoginButton(auth),
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
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSantriSearch() {
    return Autocomplete<Santri>(
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
                    onTap: () => onSelected(option),
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
            labelText: 'Masukkan Nama Santri',
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
    );
  }
  Widget _buildDropdownKelas() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: _selectedKodeKelas,
        decoration: InputDecoration(
          labelText: 'Kode Kelas',
          filled: true,
          fillColor: Colors.white.withOpacity(0.1), // Field tetap transparan
          labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(color: Colors.white),
          ),
          prefixIcon: Icon(Icons.class_, color: Colors.white.withOpacity(0.8)),
        ),
        items: _kelasList
            .map((kelas) => DropdownMenuItem(
                  value: kelas.kode,
                  child: Text(
                    kelas.kode,
                    style: TextStyle(color: Colors.black), 
                  ),
                ))
            .toList(),
        selectedItemBuilder: (context) => _kelasList
            .map((kelas) => Text(
                  kelas.kode,
                  style: TextStyle(color: Colors.white), 
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedKodeKelas = value;
          });
        },
        validator: (value) => value == null ? 'Pilih kode kelas' : null,
        dropdownColor: Colors.white, 
        iconEnabledColor: Colors.white, 
      ),
    );
  }
  Widget _buildDatePicker() {
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
                  ? 'Tanggal Lahir'
                  : DateFormat('yyyy-MM-dd').format(selectedDate!),
              style: TextStyle(color: Colors.white.withOpacity(0.9)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginButton(AuthProvider auth) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : () => _login(auth),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF00695C),
          elevation: 8,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: auth.isLoading
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
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('PPATQ RAUDLATUL FALAH', 
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.8))),
          SizedBox(height: 4),
          Text('Copyright © 2025 All Rights Reserved-BETA', 
              style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.6))),
        ],
      ),
    );
  }
}