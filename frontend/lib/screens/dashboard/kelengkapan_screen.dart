import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kelengkapan_model.dart';
import '../../services/kelengkapan_service.dart';

class KelengkapanScreen extends StatefulWidget {
  const KelengkapanScreen({super.key});

  @override
  State<KelengkapanScreen> createState() => _KelengkapanScreenState();
}

class _KelengkapanScreenState extends State<KelengkapanScreen> {
  late Future<KelengkapanResponse?> _futureKelengkapan;

  @override
  void initState() {
    super.initState();
    _futureKelengkapan = KelengkapanService().fetchKelengkapan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
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
            'Kelengkapan',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: FutureBuilder<KelengkapanResponse?>(
        future: _futureKelengkapan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade400),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Memuat data kelengkapan...',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red.shade400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat data kelengkapan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Periksa koneksi internet Anda',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          final data = snapshot.data!.data;

          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_2_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data kelengkapan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data kelengkapan akan muncul di sini',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final kelengkapan = data[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Header dengan tanggal
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.shade300,
                            Colors.teal.shade400,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.calendar_today,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tanggal Pemeriksaan',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  kelengkapan.tanggal,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Content dengan detail kelengkapan
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          _buildKelengkapanSection(
                            'Perlengkapan Mandi',
                            Icons.shower,
                            Colors.blue,
                            [
                              _buildDetailItem('Status', kelengkapan.perlengkapanMandi),
                              _buildDetailItem('Catatan', kelengkapan.catatanMandi),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildKelengkapanSection(
                            'Peralatan Sekolah',
                            Icons.school,
                            Colors.green,
                            [
                              _buildDetailItem('Status', kelengkapan.peralatanSekolah),
                              _buildDetailItem('Catatan', kelengkapan.catatanSekolah),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildKelengkapanSection(
                            'Perlengkapan Diri',
                            Icons.person,
                            Colors.orange,
                            [
                              _buildDetailItem('Status', kelengkapan.perlengkapanDiri),
                              _buildDetailItem('Catatan', kelengkapan.catatanDiri),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildKelengkapanSection(String title, IconData icon, MaterialColor color, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : 'Tidak ada catatan',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: value.isNotEmpty ? Colors.grey.shade800 : Colors.grey.shade500,
                fontStyle: value.isNotEmpty ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}