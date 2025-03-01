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
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureKesehatan = apiService.searchKesehatanByNoInduk("");
  }

  void _searchData() {
    String noInduk = _searchController.text.trim();
    if (noInduk.isNotEmpty) {
      setState(() {
        futureKesehatan = apiService.searchKesehatanByNoInduk(noInduk);
      });
    }
  }

  void _resetSearch() {
    _searchController.clear();
    setState(() {
      futureKesehatan = apiService.searchKesehatanByNoInduk("");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Kesehatan Santri"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: "Cari berdasarkan No Induk",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchData,
                ),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _resetSearch,
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Kesehatan>>(
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
                        children: kesehatan.pemeriksaan.isNotEmpty
                            ? kesehatan.pemeriksaan.map((pemeriksaan) {
                                return ListTile(
                                  title: Text("Tanggal: ${DateTime.fromMillisecondsSinceEpoch(pemeriksaan["tanggal_pemeriksaan"] * 1000)}"),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Tinggi Badan: ${pemeriksaan["tinggi_badan"]} cm"),
                                      Text("Berat Badan: ${pemeriksaan["berat_badan"]} kg"),
                                      Text("Lingkar Pinggul: ${pemeriksaan["lingkar_pinggul"]} cm"),
                                      Text("Lingkar Dada: ${pemeriksaan["lingkar_dada"]} cm"),
                                      Text("Kondisi Gigi: ${pemeriksaan["kondisi_gigi"]}"),
                                    ],
                                  ),
                                );
                              }).toList()
                            : [const ListTile(title: Text("Tidak ada riwayat pemeriksaan"))],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
