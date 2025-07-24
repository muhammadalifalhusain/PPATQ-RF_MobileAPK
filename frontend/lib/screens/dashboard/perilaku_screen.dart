import 'package:flutter/material.dart';
import '../../models/perilaku_model.dart';
import '../../services/perilaku_service.dart';
import 'package:google_fonts/google_fonts.dart';


class PerilakuScreen extends StatefulWidget {
  const PerilakuScreen({super.key});

  @override
  State<PerilakuScreen> createState() => _PerilakuScreenState();
}

class _PerilakuScreenState extends State<PerilakuScreen> {
  late Future<PerilakuResponse?> _futurePerilaku;
  int? _openCardIndex;

  @override
  void initState() {
    super.initState();
    _futurePerilaku = PerilakuService().fetchPerilaku();
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
            'Perilaku',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: FutureBuilder<PerilakuResponse?>(
        future: _futurePerilaku,
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
                    'Memuat data perilaku...',
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
                    'Gagal memuat data perilaku',
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
          if (_openCardIndex == null) {
            if (data.length == 1) {
              _openCardIndex = 0; 
            } else {
              _openCardIndex = 0; 
            }
          }

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
                      Icons.psychology_outlined,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada data perilaku',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data perilaku akan muncul di sini',
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
              final perilaku = data[index];
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
                                  'Tanggal Penilaian',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  perilaku.tanggal,
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
                          _buildPerilakuSection(
                            'Karakter Umum',
                            Icons.psychology,
                            Colors.purple,
                            [
                              _buildPerilakuItem('Ketertiban', perilaku.ketertiban),
                              _buildPerilakuItem('Kedisiplinan', perilaku.kedisiplinan),
                              _buildPerilakuItem('Ketaatan Peraturan', perilaku.ketaatanPeraturan),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildPerilakuSection(
                            'Kebersihan & Kerapian',
                            Icons.cleaning_services,
                            Colors.blue,
                            [
                              _buildPerilakuItem('Kebersihan', perilaku.kebersihan),
                              _buildPerilakuItem('Kerapian', perilaku.kerapian),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildPerilakuSection(
                            'Sosial & Lingkungan',
                            Icons.groups,
                            Colors.green,
                            [
                              _buildPerilakuItem('Kesopanan', perilaku.kesopanan),
                              _buildPerilakuItem('Kepekaan Lingkungan', perilaku.kepekaanLingkungan),
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

  Widget _buildPerilakuSection(String title, IconData icon, MaterialColor color, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.shade50,
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

  Widget _buildPerilakuItem(String label, String value) {
    Color getScoreColor(String score) {
      switch (score.toLowerCase()) {
        case 'baik':
          return Colors.green;
        case 'b':
        case 'cukup':
          return Colors.orange;
        case 'kurang baik':
          return Colors.red;
        default:
          return Colors.grey.shade600;
      }
    }

    Widget getScoreWidget(String score) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: getScoreColor(score).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: getScoreColor(score).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Text(
          score,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: getScoreColor(score),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          getScoreWidget(value),
        ],
      ),
    );
  }
}