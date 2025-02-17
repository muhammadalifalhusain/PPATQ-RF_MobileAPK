import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/santri_model.dart';
import '../models/kelas_model.dart';

class SantriScreen extends StatefulWidget {
  @override
  _SantriScreenState createState() => _SantriScreenState();
}

class _SantriScreenState extends State<SantriScreen> {
  final ApiService apiService = ApiService();
  Santri? santriData;
  List<Kelas> kelasList = [];
  bool isLoading = false;

  TextEditingController namaController = TextEditingController();
  Kelas? selectedKelas;

  @override
  void initState() {
    super.initState();
    loadKelas();
  }

  void loadKelas() async {
    try {
      List<Kelas> data = await apiService.fetchKelas();
      setState(() {
        kelasList = data;
        selectedKelas = kelasList.isNotEmpty ? kelasList[0] : null;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  void searchSantri() async {
    if (selectedKelas == null) return;

    setState(() {
      isLoading = true;
    });

    Santri? result = await apiService.fetchSantri(namaController.text, selectedKelas!.code);

    setState(() {
      santriData = result;
      isLoading = false;
    });
    if (santriData == null) {
    showSantriNotFound(); // Menampilkan pesan jika santri tidak ditemukan
  }
  }

   void showSantriNotFound() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Santri Tidak Ditemukan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
          content: Text('Tidak ada data santri yang sesuai dengan pencarian Anda. Silakan coba lagi.', style: GoogleFonts.poppins()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);  // Menutup dialog
                setState(() {
                  santriData = null;  // Reset data santri
                });
              },
              child: Text('Kembali ke Pencarian', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }


@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Cari Santri", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: InputDecoration(
                labelText: "Nama Santri",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<Kelas>(
              value: selectedKelas,
              items: kelasList.map((kelas) {
                return DropdownMenuItem(
                  value: kelas,
                  child: Text(kelas.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedKelas = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Pilih Kelas",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.class_),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: searchSantri,
              icon: isLoading
                  ? CircularProgressIndicator(color: Colors.white)
                  : Icon(Icons.search),
              label: Text("Cari", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),
            santriData != null
                ? Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 4,
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Nama: ${santriData!.nama}", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("Kelas: ${santriData!.kelas}", style: GoogleFonts.poppins(fontSize: 16, color: Colors.teal)),
                          SizedBox(height: 10),
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: Image.network(
                                santriData!.photo,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person, size: 100, color: Colors.grey);
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          _buildProfileSection(
                            title: "Wali Kelas",
                            name: santriData!.employee.nama,
                            photoUrl: santriData!.employee.photoUrl,
                          ),
                          SizedBox(height: 10),
                          _buildProfileSection(
                            title: "Murroby",
                            name: santriData!.murroby.nama,
                            photoUrl: santriData!.murroby.photoUrl,
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection({required String title, required String name, required String photoUrl}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.network(
            photoUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Icon(Icons.person, size: 60, color: Colors.grey);
            },
          ),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("$title:", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(name, style: GoogleFonts.poppins(fontSize: 16)),
          ],
        ),
      ],
    );
  }
}