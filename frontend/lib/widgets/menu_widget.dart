import 'package:flutter/material.dart';
import '../screens/about_screen.dart';

class MenuIkonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        children: [
          SizedBox(height: 10),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), // Non-scrollable grid
            crossAxisCount: 3, // 3 ikon per baris
            childAspectRatio: 1, // Rasio lebar dan tinggi ikon
            children: [
              _buildMenuIkon(Icons.info, 'About', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutPage()),
                );
              }),
              _buildMenuIkon(Icons.calendar_today, 'Agenda', () {
                // Aksi ketika Agenda ditekan
                print('Agenda diklik');
              }),
              _buildMenuIkon(Icons.photo_library, 'Galeri', () {
                // Aksi ketika Galeri ditekan
                print('Galeri diklik');
              }),
              _buildMenuIkon(Icons.people, 'Staff', () {
                // Aksi ketika Staff ditekan
                print('Staff diklik');
              }),
              _buildMenuIkon(Icons.emoji_events, 'Prestasi', () {
                // Aksi ketika Prestasi ditekan
                print('Prestasi diklik');
              }),
              _buildMenuIkon(Icons.help_center, 'Layanan', () {
                // Aksi ketika Layanan ditekan
                print('Layanan diklik');
              }),
            ],
          ),
        ],
      ),
    );
  }

  // Fungsi untuk membangun ikon menu
  Widget _buildMenuIkon(IconData ikon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, size: 35, color: Colors.green),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}