import 'package:flutter/material.dart';
import 'package:frontend/models/pegawai_model.dart';
import '../screens/about_screen.dart';
import '../screens/agenda_screen.dart';
import '../screens/galeri_screen.dart';
import '../screens/pegawai_screen.dart';
import '../screens/dakwah_screen.dart';
import '../screens/surah_list_screen.dart';
import '../screens/keluhan_screen.dart';
import '../screens/informasi_screen.dart';
import '../services/keluhan_service.dart';

class MenuIkonWidget extends StatefulWidget {
  @override
  _MenuIkonWidgetState createState() => _MenuIkonWidgetState();
}

class _MenuIkonWidgetState extends State<MenuIkonWidget> {
  bool _showAllMenus = false;
  final List<Map<String, dynamic>> _menus = [
    {
      'icon': Icons.info,
      'label': 'PPATQ-RF ku',
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen())),
    },
    {
      'icon': Icons.calendar_today,
      'label': 'Agenda',
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => AgendaScreen())),
    },
    {
      'icon': Icons.photo_library,
      'label': 'Galeri',
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => GaleriScreen())),
    },
    {
      'icon': Icons.people,
      'label': 'Staff',
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => PegawaiDataScreen())),
    },
    {
      'icon': Icons.record_voice_over,
      'label': 'Dakwah',
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => DakwahScreen())),
    },
    {
      'icon': Icons.book,
      'label': 'AL-Quran',
      'action': (BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (_) => QuranScreen())),
    },
    {
      'icon': Icons.feedback,
      'label': 'Lainnya',
      'action': (BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => KeluhanScreen(keluhanService: KeluhanService())),
      )
    },
    {
      'icon': Icons.location_on,
      'label': 'Lokasi & Info',
      'action': (BuildContext context) => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InformasiScreen())),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final displayedMenus = _showAllMenus ? _menus : _menus.take(5).toList();

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
              ...displayedMenus.map((menu) => _buildMenuIkon(
                menu['icon'],
                menu['label'],
                () => menu['action'](context),
              )).toList(),
              
              if (!_showAllMenus) _buildMoreButton(),
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
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  _buildMoreButton() {
    return GestureDetector(
      onTap: () => setState(() => _showAllMenus = true),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center( // Widget Center utama
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Pusatkan vertikal
            crossAxisAlignment: CrossAxisAlignment.center, // Pusatkan horizontal
            children: [
              Center( // Center khusus untuk ikon
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 30,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Lainnya',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center, // Pusatkan teks
              ),
            ],
          ),
        ),
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
                ),
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
                  child: Text('Mengerti', style: TextStyle(fontSize: 16)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}