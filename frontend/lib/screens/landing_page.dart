import 'package:flutter/material.dart';
import 'package:frontend/main.dart';
import '../services/api_service.dart';
import '../models/berita_model.dart';
import '../screens/detail_berita.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../widgets/berita_card.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ApiService apiService = ApiService();
  int currentPage = 0;
  final int itemsPerPage = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 30),
            SizedBox(width: 10),
            Text(
              'PPATQ RAUDLATUL FALAH',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        backgroundColor: Colors.teal,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.login),
              title: Text('Login'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add),
              title: Text('Register'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen()));
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Berita>>(
        future: apiService.fetchBerita(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Tidak ada berita tersedia.'));
          } else {
            final startIndex = currentPage * itemsPerPage;
            final endIndex = startIndex + itemsPerPage;
            final displayedBerita = snapshot.data!.sublist(
              startIndex,
              endIndex < snapshot.data!.length ? endIndex : snapshot.data!.length,
            );

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: displayedBerita.length,
                    itemBuilder: (context, index) {
                      return BeritaCard(
                        berita: displayedBerita[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailBeritaPage(berita: displayedBerita[index]),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: currentPage > 0
                          ? () {
                              setState(() {
                                currentPage--;
                              });
                            }
                          : null,
                    ),
                    Text('Halaman ${currentPage + 1}'),
                    IconButton(
                      icon: Icon(Icons.arrow_forward),
                      onPressed: (currentPage + 1) * itemsPerPage < snapshot.data!.length
                          ? () {
                              setState(() {
                                currentPage++;
                              });
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
