import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/ketahfidzan_service.dart';
import '../models/ketahfidzan_model.dart';

class KetahfidzanScreen extends StatefulWidget {
  const KetahfidzanScreen({Key? key}) : super(key: key);

  @override
  _KetahfidzanScreenState createState() => _KetahfidzanScreenState();
}

class _KetahfidzanScreenState extends State<KetahfidzanScreen> {
  final KetahfidzanService _service = KetahfidzanService();
  KetahfidzanResponse? _ketahfidzanData;
  bool _isLoading = true;
  String _errorMessage = '';
  String _nama = '';
  String _noInduk = '';
  String _photo = '';
  String _kelas = '';

  @override
  void initState() {
    super.initState();
    _loadSantriInfo(); 
    _fetchKetahfidzanData();
  }

  Future<void> _loadSantriInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = prefs.getString('nama') ?? '';
      _noInduk = prefs.getInt('no_induk')?.toString() ?? '';
      _photo = prefs.getString('photo') ?? '';
      _kelas = prefs.getString('kelas') ?? '';
    });
  }

  Future<void> _fetchKetahfidzanData() async {
    try {
      final data = await _service.fetchKetahfidzan();
      setState(() {
        _ketahfidzanData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 1,
        toolbarHeight: 48,
        automaticallyImplyLeading: true,
        centerTitle: false,
        iconTheme: const IconThemeData(color: Colors.white), // <-- warna ikon back
        title: const Text(
          'Ketahfidzan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat data...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }


    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red[400],
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Terjadi Kesalahan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red[400],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _fetchKetahfidzanData,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

    if (_ketahfidzanData == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue[400],
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada data ketahfidzan',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center( 
              child: _buildSantriInfo(),
            ),
            const SizedBox(height: 24),
            _buildKetahfidzanData(),
          ],
        ),
      ),
    );
  }

  Widget _buildSantriInfo() {
    final imageUrl = 'https://manajemen.ppatq-rf.id/assets/img/upload/photo/$_photo';

    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(15),
      child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,     
      crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: _photo.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: _photo.isEmpty
                ? Icon(Icons.person, size: 40, color: Colors.grey[400])
                : null,
          ),
          const SizedBox(height: 12),
          Text(
            _nama.isNotEmpty ? _nama : 'Nama Tidak Tersedia',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kelas: ${_kelas.isNotEmpty ? _kelas : '-'} | No. Induk: ${_noInduk.isNotEmpty ? _noInduk : '-'}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildKetahfidzanData() {
    final ketahfidzan = _ketahfidzanData!.data.ketahfidzan;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.book,
              color: Colors.blue[800],
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'Progress Tahfidz',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...ketahfidzan.entries.map((yearEntry) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Tahun ${yearEntry.key}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...yearEntry.value.entries.map((monthEntry) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                        leading: Icon(
                          Icons.calendar_today,
                          color: Colors.blue[600],
                          size: 20,
                        ),
                        title: Text(
                          monthEntry.key,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Column(
                              children: monthEntry.value.map((entry) {
                                return _buildHafalanCard(entry);
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildHafalanCard(KetahfidzanEntry entry) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.date_range,
                  color: Colors.blue[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tanggal:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  entry.tanggalTahfidzan,
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.library_books,
                  color: Colors.blue[600],
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  'Juz:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  entry.nmJuz,
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}