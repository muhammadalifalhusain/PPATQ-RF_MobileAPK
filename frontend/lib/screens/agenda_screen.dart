import 'package:flutter/material.dart';
import 'dart:ui';
import '../services/api_service.dart';
import '../models/agenda_model.dart';
import '../widgets/app_header.dart';

class AgendaScreen extends StatefulWidget {
  const AgendaScreen({Key? key}) : super(key: key);

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  List<Agenda> agendaList = [];
  int currentPage = 1; 
  final int perPage = 5; 
  bool isLoading = false;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    fetchAgendaData();
  }

  Future<void> fetchAgendaData() async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    try {
      List<Agenda> newAgenda =
          await ApiService().fetchAgenda(perPage: perPage, page: currentPage);

      setState(() {
        agendaList = newAgenda; 
        hasMoreData = newAgenda.isNotEmpty;
      });
    } catch (e) {
      print("Gagal mengambil data agenda: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  void _nextPage() {
    if (!hasMoreData) return;

    setState(() {
      currentPage++;
    });
    fetchAgendaData();
  }

  void _previousPage() {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
      });
      fetchAgendaData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: constraints.maxHeight * 0.34,
                    bottom: 80,
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'AGENDA PPATQ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const Text(
                              'Kumpulan Agenda PPATQ RADLATUL FALAH',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Expanded(
                              child: ListView.builder(
                                itemCount: agendaList.length,
                                itemBuilder: (context, index) {
                                  final agenda = agendaList[index];
                                  return Card(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                              const Icon(Icons.calendar_today,
                                                  size: 16, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Mulai: ${agenda.tanggalMulai}',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(
                                                  Icons.calendar_today_outlined,
                                                  size: 16,
                                                  color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Selesai: ${agenda.tanggalSelesai}',
                                                style: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: currentPage > 1 ? _previousPage : null,
                            child: const Text("Sebelumnya"),
                          ),
                          const SizedBox(width: 16),
                          Text("Halaman $currentPage"),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: hasMoreData ? _nextPage : null,
                            child: const Text("Berikutnya"),
                          ),
                        ],
                      ),
                    ],
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
