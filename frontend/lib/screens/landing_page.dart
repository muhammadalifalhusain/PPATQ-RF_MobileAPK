import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/berita_model.dart';
import '../widgets/app_header.dart';
import '../widgets/berita_utama.dart';
import '../widgets/berita_slider.dart';
import '../widgets/footer_widget.dart';
import '../widgets/menu_widget.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ApiService apiService = ApiService();
  int _selectedIndex = 1;

  Future<void> _launchPSBUrl() async {
    final Uri url = Uri.parse('http://psb.ppatq-rf.id');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void _showDevelopmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                )
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.engineering,
                  size: 60,
                  color: Colors.orange,
                ),
                SizedBox(height: 20),
                Text(
                  'Sedang Dalam Pengembangan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  'This feature is currently under development. We will launch it as soon as possible!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: Text(
                    'Got it',
                    style: TextStyle(fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    if (index == 0 || index == 2) {
      _showDevelopmentDialog(context);
    } else {
      setState(() {
        _selectedIndex = index;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Menu Profil dipilih')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: AppHeader(
                showAuthButtons: true,
                showBackButton: false,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<Berita>>(
                  future: apiService.fetchBeritaFromHosting(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('Tidak ada berita tersedia.'));
                    }

                    final beritaList = snapshot.data!;
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 5.0),
                          child: GestureDetector(
                          onTap: _launchPSBUrl,
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.teal, Colors.green],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 6,
                                    offset: Offset(0, 3),
                                  )
                                ], 
                              ), 
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
                                            fontSize: 13,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Daftarkan putra/putri Anda sekarang! Klik di sini untuk informasi lebih lanjut.',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.9),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.arrow_forward_ios, color: Colors.white),
                                ],
                              ),
                            ),
                          )
                        ),
                        
                        BeritaUtama(berita: beritaList.first),
                        Divider(color: Colors.teal, thickness: 2, height: 20),
                        Text(
                          'Menu',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 5),
                        MenuIkonWidget(),
                        Text(
                          'Berita Lainnya',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 15),
                        BeritaSlider(beritaList: beritaList.sublist(1)),
                        FooterWidget(),
                      ],
                    );
                  },
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
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Akademik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Keuangan',
          ),
        ],
      ),
    );
  }
}