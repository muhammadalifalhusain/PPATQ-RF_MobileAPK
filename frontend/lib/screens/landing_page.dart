import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/berita_service.dart';
import '../models/berita_model.dart';
import '../widgets/app_header.dart';
import '../widgets/berita_utama.dart';
import '../widgets/berita_slider.dart';
import '../widgets/capain_tahfidz.dart';
import '../widgets/menu_widget.dart';
import '../models/capaian_tahfidz_model.dart';
import '../services/capaian_tahfidz_service.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final BeritaService beritaService = BeritaService();
  final CapaianTahfidzService capaianService = CapaianTahfidzService();
  int _selectedIndex = 1;

  List<BeritaItem> beritaList = [];
  CapaianTahfidzResponse? capaianResponse; 
  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  late Future<CapaianTahfidzResponse?> _capaianFuture;

  @override
  void initState() {
    super.initState();
    _loadBerita();
    _capaianFuture = _loadCapaianTahfidz(); 
  }

  Future<CapaianTahfidzResponse?> _loadCapaianTahfidz() async {
    final result = await CapaianTahfidzService.fetchCapaianTahfidz();
    if (result != null) {
      setState(() {
        capaianResponse = result;
      });
    }
    return result; 
  }

  Future<void> _launchPSBUrl() async {
    final Uri url = Uri.parse('http://psb.ppatq-rf.id');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showDevelopmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Sedang Dalam Pengembangan'),
        content: Text('Fitur ini sedang dalam proses pengembangan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Tutup')),
        ],
      ),
    );
  }

  Future<void> _loadBerita() async {
    if (isLoading || !hasMore) return;
    setState(() => isLoading = true);

    try {
      final response = await beritaService.fetchBerita(page: currentPage);
      final newBerita = response.data.data;

      setState(() {
        currentPage++;
        beritaList.addAll(newBerita);
        hasMore = response.data.nextPageUrl != null;
      });
    } catch (e) {
      debugPrint('Gagal memuat berita: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppHeader(showAuthButtons: true, showBackButton: false),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(13),
                      child: GestureDetector(
                        onTap: _launchPSBUrl,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.teal, Colors.green],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.all(14),
                          child: Row(
                            children: [
                              Icon(Icons.school, color: Colors.white, size: 40),
                              SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PENDAFTARAN SANTRI BARU',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      'Daftarkan putra/putri Anda sekarang!',
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (beritaList.isEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      )
                    else ...[
                      BeritaUtama(berita: beritaList.first),
                      Divider(),
                      Text(
                        'Menu',
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      MenuIkonWidget(),
                      FutureBuilder<CapaianTahfidzResponse?>(
                        future: _capaianFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(child: Text('Tidak ada data capaian tahfidz'));
                          }
                          final data = snapshot.data!.data;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...List.generate(data.capaianCustom.length, (index) {
                                final item = data.capaianCustom[index];
                                return CapaianCard(
                                  title: 'Capaian',
                                  data: item,
                                );
                              }),

                              const SizedBox(height: 4),
                              CapaianCard(
                                title: 'Terendah',
                                data: data.terendah,
                              ),
                            ],
                          );
                        },
                      ),
                      Text('Berita Lainnya', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                      SizedBox(height: 10),
                      BeritaScreen(
                        beritaList: beritaList.sublist(1),
                        onReachEnd: _loadBerita,
                      ),
                    ],
                    if (isLoading)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar dihilangkan, diganti shadow dari bawah ke atas
      extendBody: true,
      bottomSheet: IgnorePointer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00897B), // Colors.teal
            blurRadius: 44,
            spreadRadius: 0,
            offset: Offset(0, -24),
          ),
          BoxShadow(
            color: Color(0xFF388E3C), // Colors.green
            blurRadius: 44,
            spreadRadius: 0,
            offset: Offset(0, -24),
          ),
        ],
          ),
          child: SizedBox(
        height: 4,
        width: double.infinity,
          ),
        ),
      ),
    );
  }
}
