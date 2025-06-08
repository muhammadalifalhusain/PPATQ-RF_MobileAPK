import 'package:flutter/material.dart';

import '../models/ketahfidzan_model.dart';
import '../services/ketahfidzan_service.dart';

class KetahfidzanScreen extends StatefulWidget {
  @override
  _KetahfidzanScreenState createState() => _KetahfidzanScreenState();
}

class _KetahfidzanScreenState extends State<KetahfidzanScreen> {
  late Future<ApiResponse> futureKetahfidzan;

  @override
  void initState() {
    super.initState();
    futureKetahfidzan = KetahfidzanService().fetchKetahfidzan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ketahfidzan'),
      ),
      body: FutureBuilder<ApiResponse>(
        future: futureKetahfidzan,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.ketahfidzan.data.length,
              itemBuilder: (context, index) {
                String year = data.ketahfidzan.data.keys.elementAt(index);
                return ExpansionTile(
                  title: Text(year),
                  children: data.ketahfidzan.data[year]!.entries.map((entry) {
                    String month = entry.key;
                    List<Juz> juzList = entry.value;
                    return ExpansionTile(
                      title: Text(month),
                      children: juzList.map((juz) {
                        return ListTile(
                          title: Text(juz.nmJuz),
                          subtitle: Text(juz.tanggal),
                        );
                      }).toList(),
                    );
                  }).toList(),
                );
              },
            );
          }
        },
      ),
    );
  }
}