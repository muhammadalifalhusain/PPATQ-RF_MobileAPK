import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/pembayaran_model.dart';

class PembayaranScreen extends StatefulWidget {
  @override
  _PembayaranScreenState createState() => _PembayaranScreenState();
}

class _PembayaranScreenState extends State<PembayaranScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Pembayaran>> futurePembayaran;
  final _periodeController = TextEditingController(text: '0'); // default semua periode
  final _tahunController = TextEditingController(text: DateTime.now().year.toString());

  @override
  void initState() {
    super.initState();
    futurePembayaran = apiService.getPembayaran(
      periode: int.parse(_periodeController.text),
      tahun: int.parse(_tahunController.text),
    );
  }

  void _fetch() {
    setState(() {
      futurePembayaran = apiService.getPembayaran(
        periode: int.parse(_periodeController.text),
        tahun: int.parse(_tahunController.text),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Riwayat Pembayaran')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _periodeController,
                  decoration: InputDecoration(labelText: 'Periode (0=Semua)'),
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _tahunController,
                  decoration: InputDecoration(labelText: 'Tahun'),
                  keyboardType: TextInputType.number,
                ),
              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _fetch,
              )
            ]),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Pembayaran>>(
                future: futurePembayaran,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());
                  if (snapshot.hasError)
                    return Center(child: Text('Gagal memuat: ${snapshot.error}'));
                  final data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final bayar = data[index];
                      return ListTile(
                        title: Text("Rp${bayar.jumlah}"),
                        subtitle: Text("${bayar.tanggalBayar} - ${bayar.periode}/${bayar.tahun}"),
                        trailing: bayar.bukti != null
                            ? Icon(Icons.attachment, color: Colors.green)
                            : null,
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
