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
            padding: const EdgeInsets.all(12),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.nama,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )),
                      const SizedBox(height: 8),
                      _buildRow('Tanggal', item.tanggal),
                      _buildRow('Buang Sampah', item.buangSampah),
                      _buildRow('Menata Peralatan', item.menataPeralatan),
                      _buildRow('Tidak Berseragam', item.tidakBerseragam),
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
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text('$label:',
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(flex: 3, child: Text(value)),
        ],
      ),
    );
  }
}
