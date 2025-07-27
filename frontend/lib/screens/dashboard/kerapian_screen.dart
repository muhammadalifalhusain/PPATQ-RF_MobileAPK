import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/kerapian_model.dart';
import '../../services/kerapian_service.dart';

class KerapianScreen extends StatefulWidget {
  const KerapianScreen({super.key});

  @override
  State<KerapianScreen> createState() => _KerapianScreenState();
}

class _KerapianScreenState extends State<KerapianScreen> {
  late Future<KerapianResponse> _futureKerapian;

  @override
  void initState() {
    super.initState();
    _futureKerapian = KerapianService().getDataKerapian();
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
          icon: const Icon(Icons.chevron_left, size: 32, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Kerapian',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: FutureBuilder<KerapianResponse>(
        future: _futureKerapian,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Terjadi kesalahan: ${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final data = snapshot.data?.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text('Belum ada data kerapian'));
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
                              Colors.teal.withOpacity(0.1),
                              Colors.teal.withOpacity(0.05),
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
                                color: Colors.teal,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.person,
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
                          ],
                        ),
                      ),
                      // Content Card
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildDetailSection('Kebersihan Personal', [
                              _buildDetailItem(Icons.checkroom, 'Sandal', item.sandal),
                              _buildDetailItem(Icons.checkroom, 'Sepatu', item.sepatu),
                              _buildDetailItem(Icons.soap, 'Alat Mandi', item.alatMandi),
                            ]),
                            const SizedBox(height: 16),
                            _buildDetailSection('Lainnya', [
                              _buildDetailItem(Icons.inventory_2, 'Box Jajan', item.boxJajan),
                              _buildDetailItem(Icons.next_plan, 'Tindak Lanjut', item.tindakLanjut),
                              _buildDetailItem(Icons.person_outline, 'Pengisi', item.namaPengisi),
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
            color: Colors.teal[700],
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
          color: Colors.teal[600],
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
              color: _getStatusColor(value),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _getStatusTextColor(value),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'ditata':
        return Colors.green[100]!;
      case 'tidak ditata':
        return Colors.red[100]!;
      default:
        return Colors.blue[100]!;
    }
  }

  Color _getStatusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'ditata':
        return Colors.green[700]!;
      case 'tidak ditata':
        return Colors.black;
      default:
        return Colors.blue[700]!;
    }
  }
}