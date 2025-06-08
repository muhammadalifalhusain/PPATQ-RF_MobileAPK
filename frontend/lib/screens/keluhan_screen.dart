import 'package:flutter/material.dart';
import '../models/keluhan_model.dart';
import '../models/get-santri_model.dart';
import '../services/keluhan_service.dart';
import '../services/get-santri_service.dart';
import '../models/kelas_model.dart';
import '../services/get-kelas_service.dart';
import '../models/kategori_keluhan_model.dart'; // Tambahkan ini
import '../services/kategori_keluhan_service.dart'; // Tambahkan ini

class KeluhanScreen extends StatefulWidget {
  final KeluhanService keluhanService;

  const KeluhanScreen({Key? key, required this.keluhanService}) : super(key: key);

  @override
  State<KeluhanScreen> createState() => _KeluhanScreenState();
}

class _KeluhanScreenState extends State<KeluhanScreen> {
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
  final TextEditingController _idKategoriController = TextEditingController();

  List<Santri> _allSantri = [];
  List<Santri> _filteredSantri = [];
  Santri? _selectedSantri;

  List<Kelas> _kelasList = [];
  String? _selectedKodeKelas;

  List<KategoriKeluhan> _kategoriKeluhanList = []; // Tambahkan ini
  KategoriKeluhan? _selectedKategoriKeluhan; // Tambahkan ini

  int _rating = 5;
  String _selectedJenis = 'Keluhan';
  final List<String> _jenisLaporan = ['Keluhan', 'Aduan'];

  bool _isLoading = false;
  bool _isSubmitted = false;
  bool _isSearching = false;
  bool _isLoadingSantri = false;
  bool _isLoadingKelas = false;
  bool _isLoadingKategoriKeluhan = false; // Tambahkan ini

  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _animationCurve = Curves.easeInOut;

  @override
  void initState() {
    super.initState();
    _loadSantriData();
    _loadKelasData();
    _loadKategoriKeluhan(); // Tambahkan ini
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadSantriData() async {
    setState(() => _isLoadingSantri = true);
    try {
      final response = await SantriService.fetchAllSantri();
      setState(() {
        _allSantri = response.data;
        _filteredSantri = _allSantri;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data santri: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoadingSantri = false);
    }
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

  Future<void> _loadKategoriKeluhan() async { // Tambahkan ini
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

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredSantri = _allSantri.where((santri) {
        final nama = santri.nama.toLowerCase();
        final noInduk = santri.noInduk?.toLowerCase() ?? '';
        return nama.contains(query) || noInduk.contains(query);
      }).toList();
    });
  }

  void _selectSantri(Santri santri) {
    setState(() {
      _selectedSantri = santri;
      _idSantriController.text = santri.nama;
      _isSearching = false;
    });
  }

  Widget _buildSantriSearchField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cari Santri*', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Cari berdasarkan nama atau nomor induk',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _filteredSantri = _allSantri;
                        _selectedSantri = null;
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onTap: () => setState(() => _isSearching = true),
        ),
        if (_isSearching && _filteredSantri.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _filteredSantri.length,
              itemBuilder: (context, index) {
                final santri = _filteredSantri[index];
                return ListTile(
                  title: Text(santri.nama),
                  subtitle: Text(santri.noInduk ?? '-'),
                  onTap: () => _selectSantri(santri),
                );
              },
            ),
          ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdownKelas() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: _isLoadingKelas
          ? const CircularProgressIndicator()
          : DropdownButtonFormField<String>(
              value: _selectedKodeKelas,
              decoration: InputDecoration(
                labelText: 'Kode Kelas',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              items: _kelasList
                  .map((kelas) => DropdownMenuItem(
                        value: kelas.kode,
                        child: Text(kelas.kode),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedKodeKelas = value;
                });
              },
              validator: (value) => value == null ? 'Pilih kode kelas' : null,
            ),
    );
  }

  Widget _buildDropdownKategoriKeluhan() { // Tambahkan ini
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

      Keluhan keluhan = Keluhan(
        namaPelapor: _namaPelaporController.text.trim(),
        email: _emailController.text.trim(),
        noHp: _noHpController.text.trim(),
        idSantri: _idSantriController.text.trim(),
        namaWaliSantri: _namaWaliSantriController.text.trim(),
        idKategori: _selectedKategoriKeluhan?.id.toString() ?? '', // Ubah ini
        masukan: _masukanController.text.trim(),
        saran: _saranController.text.trim(),
        rating: _rating,
        jenis: _selectedJenis,
      );

      bool success = await widget.keluhanService.submitKeluhan(keluhan);

      setState(() {
        _isLoading = false;
        _isSubmitted = success;
      });

      if (success) {
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _isSubmitted = false;
              _formKey.currentState?.reset();
              _rating = 5;
              _selectedJenis = 'Keluhan';
              _idSantriController.clear();
              _searchController.clear();
              _selectedSantri = null;
              _selectedKodeKelas = null;
              _selectedKategoriKeluhan = null; // Reset kategori keluhan
            });
          }
        });
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
        const Text('Jenis Laporan*',
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
              selectedColor: Theme.of(context).primaryColor,
              labelStyle: TextStyle(
                  color: _selectedJenis == jenis ? Colors.white : null),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
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
        elevation: 1,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Sumbang Saran',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
                                    _buildTextField(
                                      controller: _noHpController,
                                      label: 'Nomor HP/WhatsApp',
                                      keyboardType: TextInputType.phone,
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
                                    const Text('Informasi Santri',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 16),
                                    _buildSantriSearchField(),
                                    _buildTextField(
                                      controller: _namaWaliSantriController,
                                      label: 'Nama Wali Santri',
                                    ),
                                    _buildDropdownKelas(),
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
                                    _buildDropdownKategoriKeluhan(), // Tambahkan ini
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