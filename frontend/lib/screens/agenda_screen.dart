import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:async';
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
  bool isInitialLoad = true;
  Timer? _debounceTimer;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadInitialData();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    await fetchAgendaData();
    setState(() => isInitialLoad = false);
  }

  Future<void> fetchAgendaData() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final newAgenda = await ApiService().fetchAgenda(
        perPage: perPage, 
        page: currentPage
      );

      setState(() {
        agendaList = newAgenda;
        hasMoreData = newAgenda.length >= perPage;
      });
    } catch (e) {
      _showErrorSnackbar("Gagal memuat data agenda");
      debugPrint("Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _scrollListener() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.position.pixels == 
          _scrollController.position.maxScrollExtent) {
        if (hasMoreData && !isLoading) {
          _nextPage();
        }
      }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      )
    );
  }

  void _nextPage() {
    if (!hasMoreData) return;
    
    setState(() => currentPage++);
    _scrollToTop();
    fetchAgendaData();
  }

  void _previousPage() {
    if (currentPage <= 1) return;
    
    setState(() => currentPage--);
    _scrollToTop();
    fetchAgendaData();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildInitialLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text("Memuat agenda..."),
        ],
      ),
    );
  }

  Widget _buildAgendaList() {
    return ListView.builder(
      controller: _scrollController,
      itemCount: agendaList.length + (hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= agendaList.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        
        final agenda = agendaList[index];
        return _buildAgendaCard(agenda);
      },
    );
  }

  Widget _buildAgendaCard(Agenda agenda) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              agenda.judul,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('Mulai: ${agenda.tanggalMulai}', 
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                SizedBox(width: 4),
                Text('Selesai: ${agenda.tanggalSelesai}', 
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Header placeholder untuk spacing
                SizedBox(height: MediaQuery.of(context).size.height * 0.34),
                
                // Konten utama
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 80),
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
                                style: TextStyle(fontSize: 13),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                        
                        Expanded(
                          child: isInitialLoad 
                              ? _buildInitialLoader()
                              : _buildAgendaList(),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Pagination controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: currentPage > 1 ? _previousPage : null,
                              child: Text("Sebelumnya"),
                            ),
                            SizedBox(width: 16),
                            Text("Halaman $currentPage"),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: hasMoreData ? _nextPage : null,
                              child: Text("Berikutnya"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Header blur
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.white.withOpacity(0.7),
                    child: AppHeader(
                      showAuthButtons: true,
                      showBackButton: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}