import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart'; 
import '../../models/login_model.dart'; 
import '../../providers/auth_provider.dart'; 

import '../../screens/kesehatan_screen.dart';

class ProfileDashboard extends StatefulWidget {
  @override
  _ProfileDashboardState createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  LoginResponse? _loginData;
  Map<String, dynamic> additionalData = {
    'alamat': '', 
    'wali': '', 
    'saldo': 50000, 
    'kamar': '', 
  };

  final List<Map<String, dynamic>> menuItems = [
    {'icon': FontAwesome.hospital_o, 'label': 'Kesehatan'},
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

  Future<void> _loadLoginData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    setState(() {
      _loginData = authProvider.loginResponse;
      additionalData['alamat'] = _loginData!.alamat; 
      additionalData['wali'] = _loginData!.namaAyah; 
      additionalData['kamar'] = _loginData!.kamar; 
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

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade300, Colors.teal.shade600],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.3),
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.account_balance_wallet, color: Colors.white, size: 30),
                          SizedBox(height: 5),
                          Text(
                            'Saldo',
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Rp. 1.000.000',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.green.shade400, Colors.green.shade600],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.trending_up, color: Colors.white, size: 28),
                                SizedBox(height: 10),
                                Text(
                                  'Uang Masuk',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Rp. 500.000',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(left: 8),
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red.shade400, Colors.red.shade600],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.trending_down, color: Colors.white, size: 28),
                                SizedBox(height: 10),
                                Text(
                                  'Uang Keluar',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Rp. 200.000',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
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
                            String label = menuItems[index]['label'];
                            switch (label) {
                              case 'Kesehatan':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => KesehatanScreen()),
                                );
                                break;
                              default:
                                print('Navigasi ke: $label');
                            }
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