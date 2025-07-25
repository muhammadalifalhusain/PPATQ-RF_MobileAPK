import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/ketertiban_model.dart';
import '../../services/ketertiban_service.dart';

class KetertibanScreen extends StatefulWidget {
  const KetertibanScreen({super.key});

  @override
  State<KetertibanScreen> createState() => _KetertibanScreenState();
}

class _KetertibanScreenState extends State<KetertibanScreen> {
  late Future<KetertibanResponse> _future;

  @override
  void initState() {
    super.initState();
    _future = KetertibanService().getDataKetertiban();
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
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Terjadi kesalahan: ${snapshot.error}'),
            );
          }

          final data = snapshot.data?.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text('Belum ada data pelanggaran ketertiban'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
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
                      // Header Card
                      Container(
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red[50],
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: Colors.red[200]!,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Pelanggaran',
                                style: GoogleFonts.poppins(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Content Card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDetailSection('Jenis Pelanggaran', [
                              _buildDetailItem(Icons.delete_outline, 'Buang Sampah', item.buangSampah),
                              _buildDetailItem(Icons.inventory_2_outlined, 'Menata Peralatan', item.menataPeralatan),
                              _buildDetailItem(Icons.checkroom, 'Tidak Berseragam', item.tidakBerseragam),
                            ]),
                            const SizedBox(height: 16),
                            _buildDetailSection('Informasi Tambahan', [
                              _buildDetailItem(Icons.person_outline, 'Pengisi Data', item.namaPengisi),
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
            color: Colors.red[700],
          ),
        ),
        const SizedBox(height: 8),
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

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.red[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getViolationColor(value),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getViolationTextColor(value),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getViolationColor(String status) {
    // Untuk pelanggaran, biasanya "Ya" = ada pelanggaran, "Tidak" = tidak ada pelanggaran
    switch (status.toLowerCase()) {
      case 'tidak':
      case 'tidak ada':
      case 'baik':
        return Colors.green[100]!;
      case 'ya':
      case 'ada':
      case 'melanggar':
        return Colors.red[100]!;
      case 'kadang':
      case 'jarang':
        return Colors.orange[100]!;
      default:
        return Colors.blue[100]!;
    }
  }

  Color _getViolationTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'tidak':
      case 'tidak ada':
      case 'baik':
        return Colors.green[700]!;
      case 'ya':
      case 'ada':
      case 'melanggar':
        return Colors.red[700]!;
      case 'kadang':
      case 'jarang':
        return Colors.orange[700]!;
      default:
        return Colors.blue[700]!;
    }
  }
}