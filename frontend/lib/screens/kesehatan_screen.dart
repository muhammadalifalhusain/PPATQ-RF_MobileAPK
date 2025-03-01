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
            return Center(child: Text("Terjadi kesalahan: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data kesehatan santri"));
          }

          List<Kesehatan> kesehatanList = snapshot.data!;

          return ListView.builder(
            itemCount: kesehatanList.length,
            itemBuilder: (context, index) {
              Kesehatan kesehatan = kesehatanList[index];

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
                    return ListTile(
                      title: Text("Tanggal: ${pemeriksaan.tanggalPemeriksaan}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tinggi Badan: ${pemeriksaan.tinggiBadan} cm"),
                          Text("Berat Badan: ${pemeriksaan.beratBadan} kg"),
                          if (pemeriksaan.lingkarPinggul != null)
                            Text("Lingkar Pinggul: ${pemeriksaan.lingkarPinggul} cm"),
                          if (pemeriksaan.lingkarDada != null)
                            Text("Lingkar Dada: ${pemeriksaan.lingkarDada} cm"),
                          if (pemeriksaan.kondisiGigi != null)
                            Text("Kondisi Gigi: ${pemeriksaan.kondisiGigi}"),
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
}
