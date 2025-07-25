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
  int? _openCardIndex;

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
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.white),
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
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade400),
                strokeWidth: 3,
              ),
            );
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text('Gagal memuat data kelengkapan'));
          }

          final data = snapshot.data!.data;
          if (_openCardIndex == null && data.isNotEmpty) {
            _openCardIndex = data.length == 1 ? 0 : 0; 
          }
          if (data.isEmpty) {
            return const Center(child: Text('Belum ada data kelengkapan'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final kelengkapan = data[index];
              final isOpen = _openCardIndex == index;

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
                          IconButton(
                            icon: Icon(
                              isOpen ? Icons.expand_less : Icons.expand_more,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _openCardIndex = isOpen ? null : index;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    if (isOpen)
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
                            const SizedBox(height: 8),
                            _buildKelengkapanSection(
                              'Peralatan Sekolah',
                              Icons.school,
                              Colors.green,
                              [
                                _buildDetailItem('Status', kelengkapan.peralatanSekolah),
                                _buildDetailItem('Catatan', kelengkapan.catatanSekolah),
                              ],
                            ),
                            const SizedBox(height: 8),
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
          child: Column(children: children),
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
            style: TextStyle(fontSize: 14, color: Colors.grey),
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
