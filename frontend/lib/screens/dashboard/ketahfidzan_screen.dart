import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/ketahfidzan_service.dart';
import '../../models/ketahfidzan_model.dart';
import 'package:google_fonts/google_fonts.dart';


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
            'Ketahfidzan',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
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
          children: const [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1565C0)),
            ),
            SizedBox(height: 16),
            Text(
              'Memuat data...',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return _buildErrorMessage();
    }

    final data = _ketahfidzanData?.data.ketahfidzan;

    if (_ketahfidzanData == null || data == null || data.isEmpty) {
      return _buildEmptyDataMessage();
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: _buildSantriInfo()),
            const SizedBox(height: 24),
            _buildKetahfidzanData(),
          ],
        ),
      ),
    );
  }


  Widget _buildErrorMessage() {
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

  Widget _buildEmptyDataMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.info_outline,
              color: Colors.blue[400],
              size: 60,
            ),
            const SizedBox(height: 16),
            const Text(
              'Data Ketahfidzan Kosong',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Saat ini tidak ada catatan hafalan untuk santri ini. '
              'Silakan periksa kembali nanti atau hubungi pihak pengelola jika Anda merasa ini adalah kesalahan.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
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
                            child: monthEntry.value.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(bottom: 12.0),
                                    child: Text(
                                      'Belum ada hafalan yang tercatat untuk bulan ini.',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : Column(
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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan tanggal dan indikator visual
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.blue[700],
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.tanggalTahfidzan,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getScoreColor(entry.hafalan),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    entry.hafalan,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Informasi Juz
            _buildInfoRow(
              icon: Icons.book,
              label: 'Juz',
              value: entry.nmJuz,
            ),
            
            const Divider(height: 24, thickness: 0.5),
            
            // Grid untuk nilai-nilai
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              children: [
                _buildScoreItem('Hafalan', entry.hafalan),
                _buildScoreItem('Tilawah', entry.tilawah),
                _buildScoreItem('Kefasihan', entry.kefasihan),
                _buildScoreItem('Daya Ingat', entry.dayaIngat),
                _buildScoreItem('Kelancaran', entry.kelancaran),
                _buildScoreItem('Tajwid', entry.praktekTajwid),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Detail tambahan (bisa di-expand)
            ExpansionTile(
              title: const Text(
                'Detail Tambahan',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Column(
                    children: [
                      _buildDetailRow('Makhroj', entry.makhroj),
                      _buildDetailRow('Tanafus', entry.tanafus),
                      _buildDetailRow('Waqof & Wasol', entry.waqofWasol),
                      _buildDetailRow('Ghorib', entry.ghorib),
                      _buildDetailRow('Tanggal Sistem', entry.tanggal),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
  Widget _buildScoreItem(String label, String value) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getScoreColor(value),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
            ),  // <-- Tambahkan koma di sini
          ),
          const Text(': ', style: TextStyle(color: Colors.grey)),
          Expanded(
            child: Text(
              value, 
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
  Color _getScoreColor(String score) {
    switch (score) {
      case 'A':
        return Colors.green;
      case 'B':
        return Colors.lightGreen;
      case 'C':
        return Colors.orange;
      case 'D':
        return Colors.orangeAccent;
      case 'E':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}