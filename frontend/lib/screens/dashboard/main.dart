import 'package:flutter/material.dart';
import '../kesehatan_screen.dart';
// import '../santri_screen.dart';
import '../pembayaran_screen.dart';
import '../validasi_pembayaran.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    ValidasiSantriScreen(),  // Index 0
    KesehatanScreen(),  // Index 1
    // SantriScreen(), // Index 2
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Menampilkan screen berdasarkan index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal, // Warna item yang dipilih
        unselectedItemColor: Colors.grey, // Warna item yang tidak dipilih
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Payment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Kesehatan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Santri',
          ),
        ],
      ),
    );
  }
}
