import 'package:flutter/material.dart';
import '../../models/keluhan_model.dart';
import '../../services/keluhan_service.dart';
import '../../models/kategori_keluhan_model.dart'; 
import '../../services/kategori_keluhan_service.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'keluhan_screen.dart';

import 'dart:convert';
class TambahKeluhanScreen extends StatefulWidget {
  final KeluhanService keluhanService;

  const TambahKeluhanScreen({Key? key, required this.keluhanService}) : super(key: key);

  @override
  State<TambahKeluhanScreen> createState() => _TambahKeluhanScreenState();
}

class _TambahKeluhanScreenState extends State<TambahKeluhanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  final TextEditingController _namaPelaporController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _namaWaliSantriController = TextEditingController();
  final TextEditingController _masukanController = TextEditingController();
  final TextEditingController _saranController = TextEditingController();
  final TextEditingController _idSantriController = TextEditingController();

  List<KategoriKeluhan> _kategoriKeluhanList = []; // Tambahkan ini
  KategoriKeluhan? _selectedKategoriKeluhan; // Tambahkan ini

  int _rating = 5;
  String _selectedJenis = 'Keluhan';
  final List<String> _jenisLaporan = ['Keluhan', 'Aduan'];

  bool _isLoading = false;
  bool _isSubmitted = false;
  bool _isLoadingKategoriKeluhan = false; 

  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    
    _loadKategoriKeluhan();
  }

  Future<void> _loadKategoriKeluhan() async { 
    setState(() => _isLoadingKategoriKeluhan = true);
    try {
      _kategoriKeluhanList = await KategoriKeluhanService.fetchKategoriKeluhan();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat kategori keluhan: $e')),
      );
    } finally {
      setState(() => _isLoadingKategoriKeluhan = false);
    }
  }

  
  Widget _buildDropdownKategoriKeluhan() { 
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _isLoadingKategoriKeluhan
          ? const CircularProgressIndicator()
          : DropdownButtonFormField<KategoriKeluhan>(
              value: _selectedKategoriKeluhan,
              decoration: InputDecoration(
                labelText: 'Kategori Keluhan',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: _kategoriKeluhanList
                  .map((kategori) => DropdownMenuItem(
                        value: kategori,
                        child: Text(kategori.nama),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKategoriKeluhan = value;
                });
              },
              validator: (value) => value == null ? 'Pilih kategori keluhan' : null,
            ),
    );
  }

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      _scrollController.animateTo(
        0,
        duration: _animationDuration,
        curve: _animationCurve,
      );

      final prefs = await SharedPreferences.getInstance();
      final loginJson = prefs.getString('login_data');
      final loginData = loginJson != null ? json.decode(loginJson) : {};

      Keluhan keluhan = Keluhan(
        namaPelapor: _namaPelaporController.text.trim(),
        email: _emailController.text.trim(),
        noHp: loginData['noHp'] ?? _noHpController.text.trim(),
        idSantri: prefs.getInt('noInduk') ?? 0,
        namaWaliSantri: loginData['namaAyah'] ?? _namaWaliSantriController.text.trim(),
        idKategori: _selectedKategoriKeluhan?.id,
        masukan: _masukanController.text.trim(),
        saran: _saranController.text.trim(),
        rating: _rating,
        jenis: _selectedJenis,
      );

      try {
        bool success = await widget.keluhanService.submitKeluhan(keluhan);

        setState(() {
          _isLoading = false;
        });

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Keluhan berhasil dikirim!')),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        setState(() => _isLoading = false);

        final errorMessage = e.toString().replaceFirst('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _namaPelaporController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _idSantriController.dispose();
    _namaWaliSantriController.dispose();
    _masukanController.dispose();
    _saranController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isRequired = true,
    TextInputType? keyboardType,
    int? maxLines = 1,
    String? helperText,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: Colors.grey[50],
        ),
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator ??
            (isRequired
                ? (value) =>
                    value == null || value.isEmpty ? '$label wajib diisi' : null
                : null),
      ),
    );
  }

  Widget _buildJenisLaporan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Jenis Laporan',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _jenisLaporan.map((jenis) {
            return ChoiceChip(
              label: Text(jenis),
              selected: _selectedJenis == jenis,
              onSelected: (selected) {
                setState(() {
                  _selectedJenis = selected ? jenis : _selectedJenis;
                });
              },
              selectedColor: Colors.teal,
              labelStyle: TextStyle(
                  color: _selectedJenis == jenis ? Colors.white : null),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
                  showCheckmark: false, 
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Rating Kepuasan (1-10)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _rating.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: _rating.toString(),
                onChanged: (value) {
                  setState(() {
                    _rating = value.toInt();
                  });
                },
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                _rating.toString(),
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSuccessMessage() {
    return AnimatedOpacity(
      opacity: _isSubmitted ? 1.0 : 0.0,
      duration: _animationDuration,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Laporan Anda berhasil dikirim. Terima kasih atas masukan Anda!',
                style: TextStyle(color: Colors.green[800]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
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
            'Sumbang Saran',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: Column(
                          children: [
                            if (_isSubmitted) _buildSuccessMessage(),
                            Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Informasi Pelapor',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 16),
                                    _buildJenisLaporan(),
                                    _buildTextField(
                                        controller: _namaPelaporController,
                                        label: 'Nama Pelapor'),
                                    _buildTextField(
                                      controller: _emailController,
                                      label: 'Email',
                                      isRequired: false,
                                      keyboardType: TextInputType.emailAddress,
                                      helperText: 'Opsional',
                                      validator: (value) {
                                        if (value != null &&
                                            value.isNotEmpty &&
                                            !RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                                .hasMatch(value)) {
                                          return 'Format email tidak valid';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Card(
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Isi Laporan',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 16),
                                    _buildDropdownKategoriKeluhan(), 
                                    _buildTextField(
                                      controller: _masukanController,
                                      label: 'Detail Laporan',
                                      maxLines: 3,
                                    ),
                                    _buildTextField(
                                      controller: _saranController,
                                      label: 'Saran/Masukan',
                                      maxLines: 3,
                                      isRequired: false,
                                    ),
                                    _buildRatingSection(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        child: const Text('KIRIM LAPORAN',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}