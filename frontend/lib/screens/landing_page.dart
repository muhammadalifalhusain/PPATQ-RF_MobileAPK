import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/berita_model.dart';
import '../widgets/menu_drawer.dart';
import '../widgets/app_header.dart';
import '../widgets/berita_utama.dart';
import '../widgets/berita_slider.dart';
import '../widgets/footer_widget.dart';

class LandingPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: MenuDrawer(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppHeader(),
              FutureBuilder<List<Berita>>(
                future: apiService.fetchBerita(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError) return Center(child: Text('Error: ${snapshot.error}'));
                  if (!snapshot.hasData || snapshot.data!.isEmpty) return Center(child: Text('Tidak ada berita tersedia.'));
                  
                  final beritaList = snapshot.data!;
                  return Column(
                    children: [
                      BeritaUtama(berita: beritaList.first),
                      Text('Berita Lainnya', style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic)),
                      BeritaSlider(beritaList: beritaList.sublist(1)),
                      FooterWidget(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
