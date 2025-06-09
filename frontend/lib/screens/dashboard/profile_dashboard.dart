import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dashboard Santri',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ProfileDashboard(),
    );
  }
}

class ProfileDashboard extends StatefulWidget {
  @override
  _ProfileDashboardState createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  // Data santri yang akan diambil dari SharedPreferences
  Map<String, dynamic> santriData = {
    'nama': 'Loading...',
    'alamat': 'Jl. Pesantren No. 123, Cirebon',
    'wali': 'Bapak Sudirman',
    'saldo': 1250000,
    'kelas': 'Loading...',
    'asrama': 'Asrama Putra B',
    'no_induk': '',
    'kode': '',
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
    _loadUserData();
  }

  // Fungsi untuk mengambil data dari SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    
    setState(() {
      santriData['nama'] = prefs.getString('nama') ?? 'Nama tidak tersedia';
      santriData['no_induk'] = prefs.getString('no_induk') ?? '';
      santriData['kode'] = prefs.getString('kode') ?? '';
      
      // Jika Anda juga menyimpan data kelas dari login response
      // santriData['kelas'] = prefs.getString('kelas') ?? 'Kelas tidak tersedia';
      
      // Untuk sementara, kelas masih menggunakan data dummy
      // Anda bisa menggantinya jika data kelas juga disimpan dari login
      santriData['kelas'] = 'XII IPA'; // Ganti dengan data dari SharedPreferences jika ada
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Santri'),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Aksi untuk edit profil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian profil
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/images/logo.png'), // Ganti dengan path gambar profil
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 15),
                  Text(
                    santriData['nama'],
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Kelas: ${santriData['kelas']} | ${santriData['asrama']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  // Tambahan: Menampilkan No. Induk jika diperlukan
                  if (santriData['no_induk'].isNotEmpty)
                    Text(
                      'No. Induk: ${santriData['no_induk']}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
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
                  // Card Saldo
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Saldo Saat Ini',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Rp ${santriData['saldo'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                icon: Icon(Icons.add, size: 18),
                                label: Text('Top Up'),
                                onPressed: () {
                                  // Aksi untuk top up saldo
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              OutlinedButton.icon(
                                icon: Icon(Icons.history, size: 18),
                                label: Text('Riwayat'),
                                onPressed: () {
                                  // Aksi untuk melihat riwayat transaksi
                                },
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Info Santri
                  Text(
                    'Informasi Santri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildInfoItem(Icons.person, 'Nama', santriData['nama']),
                  _buildInfoItem(Icons.badge, 'No. Induk', santriData['no_induk']),
                  _buildInfoItem(Icons.code, 'Kode', santriData['kode']),
                  _buildInfoItem(Icons.home, 'Alamat', santriData['alamat']),
                  _buildInfoItem(Icons.people, 'Wali Santri', santriData['wali']),
                  _buildInfoItem(Icons.school, 'Kelas', santriData['kelas']),
                  _buildInfoItem(Icons.night_shelter, 'Asrama', santriData['asrama']),
                ],
              ),
            ),
            
            // Menu Dashboard
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
                      // Navigasi ke halaman sesuai menu
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

  // Widget untuk menampilkan item informasi
  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue),
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