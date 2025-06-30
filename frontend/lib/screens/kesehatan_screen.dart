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
  String _displayValue(dynamic value) {
  return (value == null || value.toString().isEmpty) ? '-' : value.toString();
}


  @override
  void initState() {
    super.initState();
    _kesehatanFuture = _service.getKesehatanData();
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
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Kesehatan',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade300, Colors.lightGreen.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorPadding: const EdgeInsets.all(6),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.white.withOpacity(0.7),
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16, 
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16, 
                    ),
                    tabs: const [
                      Tab(text: 'Riwayat'),
                      Tab(text: 'CheckUp'),
                      Tab(text: 'Rawat'),
                    ],
                  ),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      itemCount: pemeriksaan.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final periksa = pemeriksaan[index];
        return Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  Colors.grey[50]!,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan tanggal
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.teal[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.teal[100]!,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.teal[400],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          DateTime.fromMillisecondsSinceEpoch(periksa.tanggalPemeriksaan * 1000)
                              .toLocal()
                              .toString()
                              .split(" ")[0],
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.teal[700],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildDetailRow('Tinggi Badan (cm)', _displayValue(periksa.tinggiBadan)),
                        const SizedBox(height: 8),
                        _buildDetailRow('Berat Badan (kg)', _displayValue(periksa.beratBadan)),
                        const SizedBox(height: 8),
                        _buildDetailRow('Lingkar Pinggul (cm)', _displayValue(periksa.lingkarPinggul)),
                        const SizedBox(height: 8),
                        _buildDetailRow('Lingkar Dada (cm)', _displayValue(periksa.lingkarDada)),
                        const SizedBox(height: 8),
                        _buildDetailRow('Kondisi Gigi', _displayValue(periksa.kondisiGigi)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          ':',
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
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
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Masuk',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        DateTime.fromMillisecondsSinceEpoch(rawat.tanggalMasuk * 1000)
                            .toLocal()
                            .toString()
                            .split(" ")[0],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tanggal Keluar',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        rawat.tanggalKeluar != null
                            ? DateTime.fromMillisecondsSinceEpoch(rawat.tanggalKeluar! * 1000)
                                .toLocal()
                                .toString()
                                .split(" ")[0]
                            : '-',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 12),
              
              // Keluhan
              Text(
                'Keluhan',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                _displayValue(rawat.keluhan),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              
              // Terapi
              Text(
                'Terapi',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                _displayValue(rawat.terapi),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
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
}