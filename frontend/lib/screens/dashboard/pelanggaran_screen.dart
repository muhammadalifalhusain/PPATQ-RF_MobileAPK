import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/pelanggaran_model.dart';
import '../../services/pelanggaran_service.dart';

class PelanggaranSantriScreen extends StatefulWidget {
  const PelanggaranSantriScreen({super.key});

  @override
  State<PelanggaranSantriScreen> createState() =>
      _PelanggaranSantriScreenState();
}

class _PelanggaranSantriScreenState extends State<PelanggaranSantriScreen> {
  late Future<PelanggaranResponse> _pelanggaranFuture;

  @override
  void initState() {
    super.initState();
    _pelanggaranFuture = PelanggaranService().getDataPelanggaran();
  }

  void _refreshData() {
    setState(() {
      _pelanggaranFuture = PelanggaranService().getDataPelanggaran();
    });
  }

  Color _getSeverityColor(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'ringan':
        return const Color.fromARGB(255, 233, 163, 106)!;
      case 'berat':
        return Colors.red;
      default:
        return Colors.grey[600]!;
    }
  }

  IconData _getSeverityIcon(String kategori) {
    switch (kategori.toLowerCase()) {
      case 'ringan':
        return FontAwesomeIcons.exclamationTriangle;
      case 'sedang':
        return FontAwesomeIcons.triangleExclamation;
      case 'berat':
      case 'tinggi':
        return FontAwesomeIcons.circleExclamation;
      default:
        return FontAwesomeIcons.question;
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
          icon: const Icon(Icons.arrow_back_ios, size: 24, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Pelanggaran',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: FutureBuilder<PelanggaranResponse>(
          future: _pelanggaranFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF5B913B)),
                    ),
                    SizedBox(height: 16),
                    Text('Memuat data pelanggaran...'),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Terjadi Kesalahan',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        '${snapshot.error}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: _refreshData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5B913B),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasData) {
              final dataList = snapshot.data!.data;

              if (dataList.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        FontAwesomeIcons.warning,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Belum Ada Data Pelanggaran',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Selamat! Tidak ada catatan pelanggaran',
                        style: TextStyle(color: Colors.grey[500]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  final pelanggaran = dataList[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getSeverityColor(pelanggaran.kategori).withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getSeverityColor(pelanggaran.kategori).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: FaIcon(
                                  _getSeverityIcon(pelanggaran.kategori),
                                  color: _getSeverityColor(pelanggaran.kategori),
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      pelanggaran.jenisPelanggaran,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.grey[800],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getSeverityColor(pelanggaran.kategori).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: _getSeverityColor(pelanggaran.kategori).withOpacity(0.3),
                                        ),
                                      ),
                                      child: Text(
                                        pelanggaran.kategori.toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                          color: _getSeverityColor(pelanggaran.kategori),
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 1,
                            color: Colors.grey[200],
                          ),
                          const SizedBox(height: 8),
                          _buildInfoRow(Icons.calendar_today, 'Tanggal', pelanggaran.tanggal),
                          _buildInfoRow(Icons.gavel, 'Hukuman', pelanggaran.hukuman),
                          _buildInfoRow(Icons.person, 'Pencatat', pelanggaran.namaPengisi),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text('Tidak ada data'));
            }
          },
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: const Color(0xFF5B913B).withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 16,
              color: const Color(0xFF5B913B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '$label: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Flexible(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}