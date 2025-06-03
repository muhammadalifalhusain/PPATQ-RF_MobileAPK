import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/kesehatan_model.dart';

class KesehatanScreen extends StatefulWidget {
  @override
  _KesehatanScreenState createState() => _KesehatanScreenState();
}

class _KesehatanScreenState extends State<KesehatanScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Kesehatan>> futureKesehatan;

  @override
  void initState() {
    super.initState();
    futureKesehatan = apiService.fetchKesehatanSantri();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Kesehatan Santri"),
        backgroundColor: Colors.teal,
      ),
      body: FutureBuilder<List<Kesehatan>>(
        future: futureKesehatan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 60),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureKesehatan = apiService.fetchKesehatanSantri();
                      });
                    },
                    child: Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.assignment_outlined, size: 60),
                  Text("Tidak ada data kesehatan santri"),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Kesehatan kesehatan = snapshot.data![index];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 3,
                child: ExpansionTile(
                  title: Text(
                    kesehatan.namaSantri,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("No Induk: ${kesehatan.noInduk}"),
                  children: kesehatan.pemeriksaan.map((pemeriksaan) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (kesehatan.pemeriksaan.indexOf(pemeriksaan) != 0)
                            Divider(),
                          Text(
                            "Tanggal: ${pemeriksaan['tanggal_pemeriksaan']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal.shade700,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildInfoRow("Tinggi Badan", "${pemeriksaan['tinggi_badan']} cm"),
                          _buildInfoRow("Berat Badan", "${pemeriksaan['berat_badan']} kg"),
                          _buildInfoRow("Lingkar Pinggul", "${pemeriksaan['lingkar_pinggul']} cm"),
                          _buildInfoRow("Lingkar Dada", "${pemeriksaan['lingkar_dada']} cm"),
                          _buildInfoRow("Kondisi Gigi", pemeriksaan['kondisi_gigi']),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}