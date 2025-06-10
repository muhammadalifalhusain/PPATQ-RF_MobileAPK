import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart'; // Impor Provider
import '../../models/login_model.dart'; // Pastikan untuk mengimpor model LoginResponse
import '../../providers/auth_provider.dart'; // Impor AuthProvider

class ProfileDashboard extends StatefulWidget {
  @override
  _ProfileDashboardState createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  LoginResponse? _loginData;

  // Data santri lainnya yang diambil dari LoginResponse
  Map<String, dynamic> additionalData = {
    'alamat': '', // Akan diisi dari _loginData
    'wali': '', // Akan diisi dari _loginData
    'saldo': 50000, // Anda bisa mengubah ini sesuai kebutuhan
    'kamar': '', // Akan diisi dari _loginData
  };

  // Menu dashboard
  final List<Map<String, dynamic>> menuItems = [
    {'icon': FontAwesome.heart, 'label': 'Kesehatan'},
    {'icon': FontAwesome.history, 'label': 'Riwayat Bayar'},
    {'icon': FontAwesome.book, 'label': 'Nilai Akademik'},
    {'icon': FontAwesome.calendar, 'label': 'Jadwal'},
    {'icon': FontAwesome.envelope, 'label': 'Pesan'},
    {'icon': FontAwesome.cog, 'label': 'Pengaturan'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  // Fungsi untuk memuat data login
  Future<void> _loadLoginData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _loginData = authProvider.loginResponse; // Ambil data dari AuthProvider
      // Mengisi additionalData dengan data dari _loginData
      additionalData['alamat'] = _loginData!.alamat; // Pastikan alamat ada di LoginResponse
      additionalData['wali'] = _loginData!.namaAyah; // Misalnya, menggunakan namaAyah sebagai wali
      additionalData['kamar'] = _loginData!.kamar; // Misalnya, menggunakan kamar sebagai kamar
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loginData == null 
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  // Bagian profil
                  Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: (_loginData != null && _loginData!.photo.isNotEmpty)
                              ? NetworkImage('https://manajemen.ppatq-rf.id/assets/img/upload/photo/${_loginData!.photo}')
                              : AssetImage('assets/images/logo.png') as ImageProvider, // fallback jika foto kosong
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: 15),
                        Text(
                          _loginData!.nama,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5),
                        if (_loginData!.kode.isNotEmpty)
                          Text(
                            'Kelas: ${_loginData!.kode} | Kamar: ${additionalData['kamar']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black.withOpacity(0.9),
                            ),
                          ),
                        Text(
                          'No. Induk: ${_loginData!.noInduk}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bagian detail santri
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.teal, 
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12), // Border radius
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0), 
                            child: Text(
                              'Informasi Santri',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white, 
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 10),
                        _buildInfoItem(Icons.home, 'Alamat', _loginData!.alamat),
                        _buildInfoItem(Icons.people, 'Wali', _loginData!.namaAyah),
                        _buildInfoItem(Icons.calendar_today, 'Tanggal Lahir', _loginData!.tanggalLahir),
                        _buildInfoItem(Icons.location_city, 'Tempat Lahir', _loginData!.tempatLahir),
                        _buildInfoItem(Icons.male, 'Jenis Kelamin', _loginData!.jenisKelamin),
                        _buildInfoItem(Icons.phone, 'No. HP', _loginData!.noHp),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        return _buildMenuCard(
                          menuItems[index]['icon'],
                          menuItems[index]['label'],
                          () {
                            print('Navigasi ke: ${menuItems[index]['label']}');
                          },
                        );
                      },
                    ),
                  ),                 
                  SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.teal),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk menu dashboard
  Widget _buildMenuCard(IconData icon, String label, VoidCallback onTap) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 30, color: Colors.blue),
              SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}