import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/dashboard/pelanggaran_screen.dart';
import '../screens/kesehatan_screen.dart';
import '../screens/dashboard/kerapian_screen.dart';
import '../screens/dashboard/ketahfidzan_screen.dart';
import '../screens/dashboard/keluhan_screen.dart';
import '../screens/dashboard/perilaku_screen.dart';
import '../screens/dashboard/kelengkapan_screen.dart';
import '../screens/dashboard/ketertiban_screen.dart';
import '../screens/dashboard/validasi_pembayaran.dart';
import '../screens/dashboard/izin_screen.dart';
import '../screens/surah_list_screen.dart';
import '../screens/pegawai_screen.dart';
import '../screens/informasi_screen.dart';
class MenuGrid extends StatefulWidget {
  const MenuGrid({Key? key}) : super(key: key);

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  bool _showAll = false;

  final List<Map<String, dynamic>> _menuItems = const [
    {
      'icon': FontAwesomeIcons.dollarSign,
      'label': 'Pembayaran',
      'color': Color(0xFF10B981),
    },
    {
      'icon': FontAwesomeIcons.hospital,
      'label': 'Kesehatan',
      'color': Color(0xFF10B981),
    },
    {
      'icon': FontAwesomeIcons.book,
      'label': 'Tahfidz',
      'color': Color(0xFF8B5CF6),
    },
    {
      'icon': FontAwesomeIcons.comments,
      'label': 'Saran',
      'color': Color(0xFF3B82F6),
    },
    {
      'icon': FontAwesomeIcons.userCheck,
      'label': 'Perilaku',
      'color': Color(0xFFF59E0B),
    },
    {
      'icon': FontAwesomeIcons.clipboardCheck,
      'label': 'Kelengkapan',
      'color': Color(0xFFEF4444),
    },
    {
      'icon': FontAwesomeIcons.basketShopping,
      'label': 'Kerapian',
      'color': Colors.brown,
    },
    {
      'icon': FontAwesomeIcons.warning,
      'label': 'Pelanggaran',
      'color': Color(0xFFEF4444),
    },
    {
      'icon': FontAwesomeIcons.listCheck,
      'label': 'Ketertiban',
      'color': Color.fromARGB(255, 227, 119, 17),
    },
    {
      'icon': FontAwesomeIcons.fileSignature,
      'label': 'Izin',
      'color': Color(0xFFEF4444),
    },
    {
      'icon': FontAwesomeIcons.quran,
      'label': 'Al-Qur\'an',
      'color': Color(0xFF6366F1),
    },
    {
      'icon': FontAwesomeIcons.userTie,
      'label': 'Pegawai',
      'color': Color(0xFF3B82F6),
    },
    {
      'icon': FontAwesomeIcons.circleInfo,
      'label': 'Informasi',
      'color': Color(0xFF10B981),
    },
  ];

  void _handleMenuTap(BuildContext context
  , String label) {
    switch (label) {
      case 'Pembayaran':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const ValidasiPembayaranScreen()));
        break;
      case 'Kesehatan':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const KesehatanScreen()));
        break;
      case 'Tahfidz':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const KetahfidzanScreen()));
        break;
      case 'Saran':
        Navigator.push(context, MaterialPageRoute(builder: (_) => KeluhanListScreen()));
        break;
      case 'Perilaku':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PerilakuScreen()));
        break;
      case 'Kelengkapan':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const KelengkapanScreen()));
        break;
      case 'Kerapian':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const KerapianScreen()));
        break;
      case 'Pelanggaran':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PelanggaranSantriScreen()));
        break;
      case 'Ketertiban':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const KetertibanScreen()));
        break;
      case 'Izin':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const IzinSantriScreen()));
        break;
      case 'Al-Qur\'an':
        Navigator.push(context, MaterialPageRoute(builder: (_) => QuranScreen()));
        break;
      case 'Pegawai':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const PegawaiDataScreen()));
        break;
      case 'Informasi':
        Navigator.push(context, MaterialPageRoute(builder: (_) => const InformasiScreen()));
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Menu "$label" belum tersedia')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = _showAll ? _menuItems : _menuItems.take(6).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.apps_rounded, color: Colors.black, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Menu Cepat',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Divider(thickness: 2, color: Colors.teal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.9,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: visibleItems.length,
            itemBuilder: (context, index) {
              final item = visibleItems[index];
              return _buildMenuCard(
                item['icon'],
                item['label'],
                item['color'],
                () => _handleMenuTap(context, item['label']),
              );
            },
          ),
        ),
        if (!_showAll && _menuItems.length > 6)
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => _showAll = true),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black),
              label: Text(
                'Lainnya',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          )
        else if (_showAll)
          Center(
            child: TextButton.icon(
              onPressed: () => setState(() => _showAll = false),
              icon: const Icon(Icons.keyboard_arrow_up, color: Colors.black),
              label: Text(
                'Sembunyikan',
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );

  }

  Widget _buildMenuCard(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.8), color],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: FaIcon(icon, size: 24, color: Colors.white),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF374151),
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
