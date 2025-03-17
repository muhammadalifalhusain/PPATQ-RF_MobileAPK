import 'package:flutter/material.dart';
import 'dart:ui'; 
import '../services/api_service.dart';
import '../models/agenda_model.dart';
import '../widgets/app_header.dart'; 
import '../widgets/footer_widget.dart'; 

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late Future<List<Agenda>> futureAgenda;

  @override
  void initState() {
    super.initState();
    futureAgenda = ApiService().fetchAgenda(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: constraints.maxHeight * 0.34,
                      bottom: 80,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'AGENDA PPATQ',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'Kumpulan Agenda PPATQ RADLATUL FALAH',
                                style: TextStyle(
                                  fontSize: 13,
                                  // fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ), // <- Ini kurung penutup Padding
                        FutureBuilder<List<Agenda>>(
                          future: futureAgenda,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasError) {
                              return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(child: Text('Tidak ada data agenda.'));
                            } else {
                              List<Agenda> agendaList = snapshot.data!;
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      itemCount: agendaList.length,
                                      itemBuilder: (context, index) {
                                        final agenda = agendaList[index];
                                        return Card(
                                          margin: const EdgeInsets.only(bottom: 16),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          elevation: 4,
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  agenda.judul,
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Mulai: ${agenda.tanggalMulai}',
                                                      style: const TextStyle(color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      'Selesai: ${agenda.tanggalSelesai}',
                                                      style: const TextStyle(color: Colors.grey),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: ClipRect(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.white.withOpacity(0.7),
                        child: const AppHeader(
                          showAuthButtons: true,
                          showBackButton: true,
                        ),
                      ),
                    ),
                  ),
                ),
               
              ],
            );
          },
        ),
      ),
    );
  }
}
