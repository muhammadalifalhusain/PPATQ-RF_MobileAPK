import 'package:flutter/material.dart';
import '../models/kesehatan_model.dart';
import '../services/kesehatan_service.dart';

class KesehatanScreen extends StatefulWidget {
  const KesehatanScreen({Key? key}) : super(key: key);

  @override
  _KesehatanScreenState createState() => _KesehatanScreenState();
}

class _KesehatanScreenState extends State<KesehatanScreen> {
  late Future<KesehatanResponse> _kesehatanFuture;
  final KesehatanService _service = KesehatanService();

  @override
  void initState() {
    super.initState();
    _kesehatanFuture = _service.getKesehatanData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Kesehatan'),
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.lightBlue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<KesehatanResponse>(
        future: _kesehatanFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 48),
                  SizedBox(height: 16),
                  Text(
                    'Gagal memuat data',
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                    ),
                    ),
                    child: Text('Coba Lagi'),
                    onPressed: () {
                      setState(() {
                        _kesehatanFuture = _service.getKesehatanData();
                      });
                    },
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Tidak ada data kesehatan',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!.data;

          return DefaultTabController(
            length: 3,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.lightBlue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: EdgeInsets.all(6),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white.withOpacity(0.7),
                    tabs: [
                      Tab(icon: Icon(Icons.history), text: 'Riwayat'),
                      Tab(icon: Icon(Icons.medical_services), text: 'CheckUp'),
                      Tab(icon: Icon(Icons.local_hospital), text: 'Rawat'),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.grey.shade50,
                          Colors.grey.shade100,
                        ],
                      ),
                    ),
                    child: TabBarView(
                      children: [
                        _buildRiwayatSakitTab(data.riwayatSakit),
                        _buildPemeriksaanTab(data.pemeriksaan),
                        _buildRawatInapTab(data.rawatInap),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRiwayatSakitTab(List<RiwayatSakit> riwayatSakit) {
    if (riwayatSakit.isEmpty) {
      return _buildEmptyState(
        icon: Icons.health_and_safety,
        message: 'Tidak ada riwayat sakit',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: riwayatSakit.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final sakit = riwayatSakit[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.medical_services, color: Colors.blue),
            ),
            title: Text(
              sakit.keluhan,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              '${sakit.tanggalSakitDate.toLocal().toString().split(' ')[0]}',
              style: TextStyle(color: Colors.grey.shade600),
            ),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      'Tanggal Sakit',
                      sakit.tanggalSakitDate.toLocal().toString().split(' ')[0],
                    ),
                    if (sakit.tanggalSembuh != null)
                      _buildDetailRow(
                        'Tanggal Sembuh',
                        sakit.tanggalSembuhDate!.toLocal().toString().split(' ')[0],
                      ),
                    _buildDetailRow('Keterangan', sakit.keteranganSakit),
                    if (sakit.keteranganSembuh != null)
                      _buildDetailRow('Keterangan Sembuh', sakit.keteranganSembuh!),
                    if (sakit.tindakan != null)
                      _buildDetailRow('Tindakan', sakit.tindakan!),
                    SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPemeriksaanTab(List<Pemeriksaan> pemeriksaan) {
    if (pemeriksaan.isEmpty) {
      return _buildEmptyState(
        icon: Icons.monitor_heart,
        message: 'Tidak ada data pemeriksaan',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: pemeriksaan.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final periksa = pemeriksaan[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.green.shade100,
                      child: Icon(Icons.assignment, color: Colors.green),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Pemeriksaan ${periksa.tanggalPemeriksaanDate.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                _buildMeasurementCard(
                  icon: Icons.height,
                  title: 'Tinggi Badan',
                  value: '${periksa.tinggiBadan} cm',
                  color: Colors.blue,
                ),
                _buildMeasurementCard(
                  icon: Icons.line_weight,
                  title: 'Berat Badan',
                  value: '${periksa.beratBadan} kg',
                  color: Colors.green,
                ),
                _buildMeasurementCard(
                  icon: Icons.straighten,
                  title: 'Lingkar Pinggul',
                  value: '${periksa.lingkarPinggul} cm',
                  color: Colors.orange,
                ),
                _buildMeasurementCard(
                  icon: Icons.straighten,
                  title: 'Lingkar Dada',
                  value: '${periksa.lingkarDada} cm',
                  color: Colors.purple,
                ),
                SizedBox(height: 8),
                Text(
                  'Kondisi Gigi:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  periksa.kondisiGigi,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRawatInapTab(List<RawatInap> rawatInap) {
    if (rawatInap.isEmpty) {
      return _buildEmptyState(
        icon: Icons.local_hospital,
        message: 'Tidak ada data rawat inap',
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(16),
      itemCount: rawatInap.length,
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemBuilder: (context, index) {
        final rawat = rawatInap[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 2)),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red.shade100,
              child: Icon(Icons.medical_services, color: Colors.red),
            ),
            title: Text(
              rawat.keluhan,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text(
                  'Masuk: ${rawat.tanggalMasukDate.toLocal().toString().split(' ')[0]}',
                  style: TextStyle(fontSize: 13),
                ),
                if (rawat.tanggalKeluar != null)
                  Text(
                    'Keluar: ${rawat.tanggalKeluarDate!.toLocal().toString().split(' ')[0]}',
                    style: TextStyle(fontSize: 13),
                  ),
              ],
            ),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              _showRawatInapDetails(context, rawat);
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      color: color.withOpacity(0.1),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Spacer(),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRawatInapDetails(BuildContext context, RawatInap rawat) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                rawat.keluhan,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              _buildDetailRow(
                'Tanggal Masuk',
                rawat.tanggalMasukDate.toLocal().toString().split(' ')[0],
              ),
              if (rawat.tanggalKeluar != null)
                _buildDetailRow(
                  'Tanggal Keluar',
                  rawat.tanggalKeluarDate!.toLocal().toString().split(' ')[0],
                ),
              _buildDetailRow('Terapi', rawat.terapi),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('Tutup'),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}