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
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildRow('Tanggal', item.tanggal),
                      _buildRow('Nama Santri', item.nama),
                      _buildRow('Sandal', item.sandal),
                      _buildRow('Sepatu', item.sepatu),
                      _buildRow('Box Jajan', item.boxJajan),
                      _buildRow('Alat Mandi', item.alatMandi),
                      _buildRow('Tindak Lanjut', item.tindakLanjut),
                      _buildRow('Pengisi', item.namaPengisi),
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

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}
