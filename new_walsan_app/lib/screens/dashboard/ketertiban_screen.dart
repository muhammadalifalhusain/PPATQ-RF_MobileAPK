import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/ketertiban_model.dart';
import '../../services/ketertiban_service.dart';
import '../../widgets/loading_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class KetertibanScreen extends StatefulWidget {
  const KetertibanScreen({super.key});

  @override
  State<KetertibanScreen> createState() => _KetertibanScreenState();
}

class _KetertibanScreenState extends State<KetertibanScreen> {
  late Future<KetertibanResponse> _future;
  int? _expandedIndex; // menyimpan index card yang terbuka

  @override
  void initState() {
    super.initState();
    _future = KetertibanService().getDataKetertiban().then((response) {
      final data = response.data;
      if (data.isNotEmpty) {
        // jika hanya 1 data atau lebih dari 1, default buka index 0
        _expandedIndex = 0;
      }
      return response;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        toolbarHeight: 56,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 24, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Ketertiban',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: FutureBuilder<KetertibanResponse>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen(
              message: 'Memuat data Ketertiban...',
              backgroundColor: Colors.teal,
              progressColor: Colors.white,
              icon: FontAwesomeIcons.listCheck,
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }

          final data = snapshot.data?.data ?? [];

          if (data.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.listCheck,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum Ada Data Ketertiban',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data akan tampil ketika data tersedia',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              final bool isExpanded = _expandedIndex == index;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Card(
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                  color: Colors.white,
                  child: Column(
                    children: [
                      // Header Card dengan GestureDetector
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isExpanded) {
                              _expandedIndex = null; // tutup jika diklik lagi
                            } else {
                              _expandedIndex = index; // buka card ini
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.withOpacity(0.1),
                                Colors.red.withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.red[600],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.warning,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.nama,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.tanggal,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.grey[700],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Content Card hanya muncul jika isExpanded true
                      if (isExpanded)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildDetailSection('Jenis Pelanggaran', [
                                _buildDetailItem('Tidak Membuang Sampah', item.buangSampah.toString()),
                                _buildDetailItem('Tidak Menata Peralatan', item.menataPeralatan.toString()),
                                _buildDetailItem('Tidak Berseragam', item.tidakBerseragam.toString()),
                              ]),
                              const SizedBox(height: 16),
                              _buildDetailSection('Informasi Tambahan', [
                                _buildDetailItem('Pengisi Data', item.namaPengisi, addSuffixKali: false),
                              ]),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: items
                .map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: item,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value, {bool addSuffixKali = true}) {
    final bool isEmpty = value.trim().isEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isEmpty ? Colors.grey[100] : Colors.blue[100],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                isEmpty
                    ? 'Tidak ada catatan'
                    : addSuffixKali
                        ? '$value kali'
                        : value,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  fontWeight: isEmpty ? FontWeight.w400 : FontWeight.w600,
                  fontStyle: isEmpty ? FontStyle.italic : FontStyle.normal,
                  color: isEmpty ? Colors.grey[500] : Colors.black,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
