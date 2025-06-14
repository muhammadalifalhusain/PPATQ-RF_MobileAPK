import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/dakwah_model.dart';
import '../services/dakwah_service.dart';
import 'package:google_fonts/google_fonts.dart';


class DakwahScreen extends StatefulWidget {
  const DakwahScreen({Key? key}) : super(key: key);

  @override
  State<DakwahScreen> createState() => _DakwahScreenState();
}

class _DakwahScreenState extends State<DakwahScreen> {
  final DakwahService _service = DakwahService();
  late Future<DakwahResponse> _futureDakwah;

  @override
  void initState() {
    super.initState();
    _futureDakwah = _service.fetchDakwah();
  }

  String formatTanggal(String tgl) {
    final date = DateTime.parse(tgl);
    return DateFormat('dd MMMM yyyy • HH:mm', 'id_ID').format(date);
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
            'Dakwah',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: FutureBuilder<DakwahResponse>(
        future: _futureDakwah,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat data dakwah."));
          }

          final dakwahList = snapshot.data!.dakwahList;

          return ListView.builder(
            itemCount: dakwahList.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final dakwah = dakwahList[index];

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (_) => Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dakwah.judul,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                formatTanggal(dakwah.createdAt),
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              const Divider(height: 24),
                              Text(
                                dakwah.isiDakwah,
                                style: const TextStyle(fontSize: 16, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dakwah.judul,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dakwah.isiDakwah.length > 100
                              ? '${dakwah.isiDakwah.substring(0, 100)}...'
                              : dakwah.isiDakwah,
                          style: const TextStyle(color: Colors.black87),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 16, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              formatTanggal(dakwah.createdAt),
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
