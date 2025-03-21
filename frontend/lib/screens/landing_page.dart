import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/api_service.dart';
import '../models/berita_model.dart';
import '../widgets/app_header.dart';
import '../widgets/berita_utama.dart';
import '../widgets/berita_slider.dart';
import '../widgets/footer_widget.dart';
import '../widgets/menu_widget.dart';

class LandingPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Konten yang bisa di-scroll
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: constraints.maxHeight * 0.35, 
                    ),
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
                              Divider(
                                color: Colors.teal,                                thickness: 2,    
                                height: 20,      
                              ),
                            Text(
                              'Menu',
                              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                            ),
                            SizedBox(height: 5), 
                            MenuIkonWidget(),
                            Text(
                              'Berita Lainnya',
                              style: TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
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
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
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
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}