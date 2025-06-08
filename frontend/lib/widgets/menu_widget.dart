import 'package:flutter/material.dart';
import 'package:frontend/models/pegawai_model.dart';
import '../screens/about_screen.dart';
import '../screens/agenda_screen.dart';
import '../screens/galeri_screen.dart';
import '../screens/pegawai_screen.dart';
import '../screens/dakwah_screen.dart';

class MenuIkonWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 13),
      child: Column(
        children: [
          SizedBox(height: 5),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(), 
            crossAxisCount: 3, 
            childAspectRatio: 1, 
            children: [
              _buildMenuIkon(Icons.info, 'About', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AboutScreen()),
                );
              }),
              _buildMenuIkon(Icons.calendar_today, 'Agenda', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AgendaScreen()),
                );
              }),
              _buildMenuIkon(Icons.photo_library, 'Galeri', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => GaleriScreen()),
                );
              }),
              _buildMenuIkon(Icons.people, 'Staff', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PegawaiDataScreen()),
                );
              }),
              _buildMenuIkon(Icons.emoji_events, 'Dakwah', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DakwahScreen()),
                );
              }),
              _buildMenuIkon(Icons.help_center, 'Layanan', () {
                _showDevelopmentDialog(context);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuIkon(IconData ikon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, size: 35, color: Colors.green),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
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
                  'Maaf, menu ini sedang dalam tahap pengembangan. Kami akan segera meluncurkannya!',
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
                    'Mengerti',
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
}