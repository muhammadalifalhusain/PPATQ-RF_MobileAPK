import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/provider.dart';
import '../../models/login_model.dart';
import '../../providers/auth_provider.dart';

import '../../screens/kesehatan_screen.dart';
import '../../screens/ketahfidzan_screen.dart';

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
    {'icon': FontAwesome.money, 'label': 'Keuangan'},
    {'icon': FontAwesome.book, 'label': 'Tahfidz'},
  ];

  @override
  void initState() {
    super.initState();
    _loadLoginData();
  }

  Future<void> _loadLoginData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    try {
      setState(() {
        _loginData = authProvider.loginResponse;
        additionalData['alamat'] = _loginData?.alamat ?? '';
        additionalData['wali'] = _loginData?.namaAyah ?? '';
        additionalData['kamar'] = _loginData?.kamar ?? '';
      });
    } catch (e) {
      print('Error loading login data: $e');
    }
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
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(1),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    (_loginData?.photo.isNotEmpty ?? false)
                                        ? NetworkImage(
                                            'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${_loginData?.photo}')
                                        : null,
                                child: (_loginData?.photo.isEmpty ?? true)
                                    ? Icon(Icons.person,
                                        size: 35, color: Colors.grey[400])
                                    : null,
                              ),
                              SizedBox(height: 12),
                              Text(_loginData?.nama ?? 'Nama Tidak Tersedia',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87)),
                              SizedBox(height: 8),
                              Text(
                                'Kelas: ${_loginData?.kelas ?? 'Kelas Tidak Tersedia'} | No.Induk: ${_loginData?.noInduk ?? 'No. Induk Tidak Tersedia'}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Saldo Section
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.shade300,
                            Colors.teal.shade600
                          ],
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
                          Icon(Icons.account_balance_wallet,
                              color: Colors.white, size: 30),
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
                  SizedBox(height: 15),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.teal,  // Warna garis
                          width: 2.0,          // Ketebalan garis
                        ),
                      ),
                    ),
                    child: Text(
                      'Menu',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0), // Reduced top padding from 20 to 10
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
                                  MaterialPageRoute(
                                      builder: (_) => KesehatanScreen()),
                                );
                                break;
                              case 'Tahfidz':
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => KetahfidzanScreen()),
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

                  Padding(
                    padding: EdgeInsets.all(15), // Reduced padding
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Card(
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 5.0),
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
                        _buildInfoItem(
                            Icons.person,
                            'Murroby',
                            '${_loginData?.namaMurroby ?? 'Tidak Tersedia'} - Kamar: ${_loginData?.kamar ?? 'Tidak Tersedia'}'),
                        _buildInfoItem(
                            Icons.person,
                            'Ustadz',
                            '${_loginData?.namaUstadTahfidz ?? 'Tidak Tersedia'} - ${_loginData?.kelasTahfidz ?? 'Tidak Tersedia'}'),
                        _buildInfoItem(Icons.home, 'Alamat',
                            _loginData?.alamat ?? 'Tidak Tersedia'),
                        _buildInfoItem(Icons.calendar_month, 'Tgl-Lahir',
                            _loginData?.tanggalLahir ?? 'Tidak Tersedia'),
                      ],
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
              Icon(icon, size: 30, color: Colors.teal),
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