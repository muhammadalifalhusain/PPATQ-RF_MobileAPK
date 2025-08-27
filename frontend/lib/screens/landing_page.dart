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
import '../widgets/pendaftaran_santri_widget.dart';
import '../utils/pendaftaran_url.dart';
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
                    EnhancedRegistrationCard(
                      onTap: launchPSBUrl,
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
                            return Center(
                              child: Text(
                                'Tidak ada data capaian tahfidz',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[700],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            );
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
                      SizedBox(height: 10),
                      Text('Berita Lainnya', style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black)),
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
      extendBody: true,
      bottomSheet: IgnorePointer(
        child: DecoratedBox(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xFF00897B),
                blurRadius: 44,
                spreadRadius: 0,
                offset: Offset(0, -24),
              ),
              BoxShadow(
                color: Color(0xFF388E3C),
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
