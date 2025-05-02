import 'package:flutter/material.dart';
import 'dart:ui';
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Menu Akademik dipilih')),
        );
        break;
      case 1:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Menu Profil dipilih')),
        );
        break;
      case 2:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Menu Keuangan dipilih')),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withOpacity(0.7),
                  child: AppHeader(
                    showAuthButtons: true,
                    showBackButton: false,
                  ),
                ),
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