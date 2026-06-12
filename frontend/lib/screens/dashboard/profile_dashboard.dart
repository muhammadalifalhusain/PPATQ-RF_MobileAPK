import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

import '../../models/login_model.dart';

import '../../widgets/menu_dashboard_widget.dart';
import '../../widgets/psp_info.dart';
class ProfileDashboard extends StatefulWidget {
  @override
  _ProfileDashboardState createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  LoginResponse? _loginData;

  Widget _buildTextRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
      });
    } catch (e) {
      print('Pesan error: $e');
    }
  }


  String formatKosong(String? value) {
    final cleaned = value?.replaceAll(',', '').trim() ?? '';
    return cleaned.isNotEmpty ? value!.trim() : '-';
  }

  @override
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.teal,
      elevation: 1,
      toolbarHeight: 48,
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'Profil',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Spacer(), 
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Text(
              'V1.1.21',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    body: _loginData == null
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
              child: Column(
                children: [
                  PspInfoCard(),
                  Column(
                    children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF003B46),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                  ),
                                ),
                                
                                Transform.translate(
                                  offset: Offset(0, -25), 
                                  child: Column(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 3,
                                          ),
                                        ),
                                        child: CircleAvatar(
                                          radius: 45, // Diperkecil dari 60 ke 45
                                          backgroundColor: Colors.grey.shade100,
                                          backgroundImage: (_loginData?.photo.isNotEmpty ?? false)
                                              ? NetworkImage(
                                                  'https://manajemen.ppatq-rf.id/assets/img/upload/photo/${_loginData?.photo}')
                                              : null,
                                          child: (_loginData?.photo.isEmpty ?? true)
                                              ? Icon(
                                                  Icons.person,
                                                  size: 32,
                                                  color: Colors.grey[400],
                                                )
                                              : null,
                                        ),
                                      ),                                      
                                      SizedBox(height: 8),
                                      Text(
                                        _loginData?.nama ?? 'Nama Tidak Tersedia',
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.grey.shade800,
                                          letterSpacing: 0.3,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                                Transform.translate(
                                  offset: Offset(0, -18), 
                                  child: Container(
                                    margin: EdgeInsets.symmetric(horizontal: 15),
                                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade50,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: const Color(0xFF003B46),
                                        width: 2.5,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Kelas: ${_loginData?.kelas ?? 'Tidak Tersedia'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 4),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'NIS: ${_loginData?.noInduk ?? 'Tidak Tersedia'}',
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.grey.shade700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),       
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const RiwayatPembayaranScreen(),
                          //       ),
                          //     );
                          //   },
                          //   borderRadius: BorderRadius.circular(16),
                          //   child: Container(
                          //     width: double.infinity,
                          //     padding: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                          //     decoration: BoxDecoration(
                          //       color: const Color.fromARGB(255, 132, 123, 123),
                          //       borderRadius: BorderRadius.circular(16),
                          //       border: Border.all(color: Colors.grey.shade200, width: 1.5),
                          //       boxShadow: [
                          //         BoxShadow(
                          //           color: Colors.black.withOpacity(0.04),
                          //           blurRadius: 8,
                          //           offset: Offset(0, 2),
                          //         ),
                          //       ],
                          //     ),
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       children: [
                          //         Icon(Icons.history, color: Colors.white, size: 20),
                          //         SizedBox(width: 10),
                          //         Text(
                          //           'Riwayat Pembayaran Pondok',
                          //           style: GoogleFonts.poppins(
                          //             color: Colors.white,
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.w500,
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),              
                MenuGrid(),
                Padding(
                  padding: EdgeInsets.all(15), 
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
                              horizontal: 12.0, vertical: 4.0),
                          child: Text(
                            'Informasi Santri',
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5),
                      _buildInfoItem(
                        Icons.person,
                        'Murroby',
                        '${formatKosong(_loginData?.namaMurroby)} - Kamar : ${formatKosong(_loginData?.kamar)}',
                      ),
                      _buildInfoItem(
                        Icons.person,
                        'Ustadz',
                        '${formatKosong(_loginData?.namaUstadTahfidz)} - ${formatKosong(_loginData?.kelasTahfidz)}',
                      ),
                      _buildInfoItem(
                        Icons.home,
                        'Alamat',
                        formatKosong(_loginData?.alamat),
                      ),
                      _buildInfoItem(
                        Icons.calendar_month,
                        'Tgl-Lahir',
                        formatKosong(_loginData?.tanggalLahir),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5), 
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: ExpansionTile(
                      title: Text(
                        'Data Ortu',
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      childrenPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 5), 
                      children: [
                        _buildTextRow('Nama Ayah', formatKosong(_loginData?.namaAyah)),
                        _buildTextRow('Pendidikan', formatKosong(_loginData?.pendidikanAyah)),
                        _buildTextRow('Pekerjaan', formatKosong(_loginData?.pekerjaanAyah)),
                        _buildTextRow('Nama Ibu', formatKosong(_loginData?.namaIbu)),
                        _buildTextRow('Pendidikan', formatKosong(_loginData?.pendidikanIbu)),
                        _buildTextRow('Pekerjaan', formatKosong(_loginData?.pekerjaanIbu)),
                        _buildTextRow('No Ortu', formatKosong(_loginData?.noHp)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      Widget _buildInfoItem(IconData icon, String label, String value) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: Colors.teal),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      value,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }
}