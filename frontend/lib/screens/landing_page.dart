import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadBerita();
    _loadCapaianTahfidz();();
  }

  Future<void> _loadCapaianTahfidz() async {
    final result = await CapaianTahfidzService.fetchCapaianTahfidz();
    if (result != null) {
      setState(() {
        capaianResponse = result;
      });
    }
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

  void _onItemTapped(int index) {
    if (index == 0 || index == 2) {
      _showDevelopmentDialog(context);
    } else {
      setState(() => _selectedIndex = index);
    }
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
                              SizedBox(width: 13),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'PENDAFTARAN SANTRI BARU',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Daftarkan putra/putri Anda sekarang!',
                                      style: TextStyle(color: Colors.white70),
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
                      Text('Menu', style: TextStyle(fontWeight: FontWeight.bold)),
                      MenuIkonWidget(),
                      if (capaianResponse?.data != null) ...[
                        CapaianCard(
                          title: 'Tertinggi',
                          data: capaianResponse!.data.tertinggi,
                        ),
                        CapaianCard(
                          title: 'Terendah',
                          data: capaianResponse!.data.terendah,
                        ),
                      ] else ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Data capaian tahfidz tidak tersedia.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                      Text('Berita Lainnya', style: TextStyle(fontWeight: FontWeight.bold)),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Akademik'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Keuangan'),
        ],
      ),
    );
  }
}
