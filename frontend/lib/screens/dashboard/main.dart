import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../screens/landing_page.dart';  
import 'validasi_pembayaran.dart';
import 'profile_dashboard.dart';

import 'package:google_fonts/google_fonts.dart';
class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 1; // Default ke Profile

  final List<Widget> _screens = [
    ValidasiPembayaranScreen(),  
    ProfileDashboard(),        
  ];

  void _onItemTapped(int index) {
    if (index == 0) {
      _confirmLogout();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _confirmLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Show modern confirmation dialog
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        icon: Icon(
          Icons.logout,
          color: Colors.red[400],
          size: 48,
        ),
        title: Text(
          'Konfirmasi Keluar',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        content: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'Apakah Anda yakin ingin keluar dari akun?',
            style: GoogleFonts.poppins(fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Text(
              'Batal',
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: Text(
              'Keluar',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      await _performLogout(authProvider);
    }
  }

  Future<void> _performLogout(AuthProvider authProvider) async {
      // Show loading dialog with better design
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Sedang keluar...',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      try {
        // Perform logout
        await authProvider.logout();
        
        // Close loading dialog if still mounted
        if (mounted) {
          Navigator.of(context).pop();
        }
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (_) => LandingPage(),
            ),
            (route) => false,
          );
        }

        // Show success message after navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showSnackBar(
              'Logout berhasil',
              Colors.green,
              Icons.check_circle,
            );
          }
        });

      } catch (e) {
        // Close loading dialog
        if (mounted) {
          Navigator.of(context).pop();
        }

        // Show error message
        if (mounted) {
          _showSnackBar(
            'Gagal logout: ${e.toString()}',
            Colors.red,
            Icons.error,
          );
        }

        // Log error for debugging
        debugPrint('Logout error: $e');
      }
    }

    void _showSnackBar(String message, Color backgroundColor, IconData icon) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.logout, color: Colors.red), 
            label: 'Keluar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
