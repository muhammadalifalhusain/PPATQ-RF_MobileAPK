import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/alumni_model.dart';
import '../../services/alumni_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/phone_formatter.dart';
import '../widgets/loading_screen.dart';
class AlumniScreen extends StatefulWidget {
  const AlumniScreen({Key? key}) : super(key: key);

  @override
  _AlumniScreenState createState() => _AlumniScreenState();
}

class _AlumniScreenState extends State<AlumniScreen> with TickerProviderStateMixin {
  List<AlumniDetail> alumniList = [];
  List<PerTahun> perTahunList = [];
  int currentPage = 1;
  bool isLoading = false;
  bool isLastPage = false;
  String? searchQuery;
  int? selectedYear;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fetchAlumni();
    _scrollController.addListener(_scrollListener);
    _fadeController.forward();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      if (!isLoading && !isLastPage) {
        _fetchAlumni();
      }
    }
  }

  Future<void> _fetchAlumni({bool refresh = false}) async {
    if (isLoading) return;

    setState(() => isLoading = true);

    if (refresh || searchQuery != null) {
      currentPage = 1;
      alumniList.clear();
      isLastPage = false;
    }

    final response = await AlumniService.fetchAlumni(search: searchQuery);

    if (response != null && response.data != null) {
      final alumniData = response.data!;

      setState(() {
        alumniList.addAll(alumniData.alumni);
        perTahunList = alumniData.perTahun;

        isLastPage = alumniData.alumni.length < 25;
        currentPage++;
      });
    }

    setState(() => isLoading = false);
  }


  List<AlumniDetail> _getFilteredAlumni() {
    if (selectedYear == null) {
      return alumniList;
    } else {
      final perTahunData = perTahunList.firstWhere(
        (element) => element.tahun == selectedYear,
        orElse: () => PerTahun(tahun: selectedYear!, data: []),
      );

      final fromAlumniList = alumniList.where((a) => a.tahunLulus == selectedYear).toList();

      final combined = [...perTahunData.data, ...fromAlumniList];

      if (combined.isEmpty) {
        return alumniList;
      }

      return combined;
    }
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final input = value.trim();
      if (input.length >= 3) {
        searchQuery = input;
        _fetchAlumni(refresh: true);
      } else if (input.isEmpty) {
        searchQuery = null;
        _fetchAlumni(refresh: true);
      }
    });
  }

  void _onYearFilterChanged(int? year) {
    setState(() {
      selectedYear = year;
    });
  }

  List<int> _getAvailableYears() {
    final years = <int>{};
    for (final perTahun in perTahunList) {
      if (perTahun.tahun != null && perTahun.tahun! > 2000) { 
        years.add(perTahun.tahun!);
      }
    }
    
    for (final alumni in alumniList) {
      if (alumni.tahunLulus != null && alumni.tahunLulus! > 2000) {
        years.add(alumni.tahunLulus!);
      }
    }
    return years.toList()..sort((a, b) => b.compareTo(a));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.teal,
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Data Alumni',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  style: GoogleFonts.poppins(),
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau NIS alumni...',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: DropdownButtonFormField<int>(
                        value: selectedYear != null && _getAvailableYears().contains(selectedYear!)
                          ? selectedYear
                          : null,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600], size: 20),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                        dropdownColor: Colors.white,
                        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF2D3748)),
                        items: [
                          const DropdownMenuItem<int>(
                            value: null, 
                            child: Text(
                              'Semua Tahun',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                          ..._getAvailableYears().map(
                            (year) => DropdownMenuItem<int>(
                              value: year,
                              child: Text(
                                '$year',
                                style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                        onChanged: _onYearFilterChanged,
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: selectedYear != null ? const Color(0xFF5B913B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selectedYear != null ? const Color(0xFF5B913B) : Colors.grey[300]!,
                      ),
                    ),
                    child: IconButton(
                      onPressed: selectedYear != null ? () => _onYearFilterChanged(null) : null,
                      icon: Icon(
                        Icons.close,
                        color: selectedYear != null ? Colors.white : Colors.grey[400],
                        size: 20,
                      ),
                      tooltip: 'Hapus Filter',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAlumniCard(AlumniDetail alumni, int index) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300 + (index * 100)),
        curve: Curves.easeOutBack,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 5),
                spreadRadius: 1,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                alumni.nama,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF5B913B).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'NIS: ${alumni.noInduk} - Tahun Lulus ${alumni.tahunLulus}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF5B913B),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow('Masa Tempuh', alumni.masaTempuh ?? '-'),
                          _buildInfoRow('Khotimin', alumni.khotimin ?? '-'),
                          _buildInfoRow('Murroby', alumni.murroby ?? '-'),
                          _buildInfoRow('Pondok MI', alumni.namaPondokMi ?? '-'),
                          _buildInfoRow('Pondok MA', alumni.namaPondokMenengahAtas ?? '-'),
                          _buildInfoRow('Perguruan Tinggi', alumni.namaPerguruanTinggi ?? '-'),
                          _buildInfoRow('Profesi', alumni.posisiProfesi ?? '-'),
                          if (alumni.noHp != null && alumni.noHp!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            InkWell(
                              onTap: () async {
                                final rawNoHp = alumni.noHp ?? '';
                                final noHp = formatPhoneToInternational(rawNoHp);
                                if (noHp.isNotEmpty) {
                                  final Uri url = Uri.parse('https://wa.me/$noHp');
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Gagal membuka WhatsApp')),
                                    );
                                  }
                                }
                              },
                              child: Row(
                                children: [
                                  const Icon(Icons.call, color: Colors.green),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Hubungi Wali Santri',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          '$label: ',
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2D3748),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.search_off,
              size: 60,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            selectedYear != null 
                ? 'Tidak ada alumni tahun $selectedYear'
                : 'Tidak ada data alumni',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            selectedYear != null
                ? 'Coba pilih tahun lain atau hapus filter'
                : 'Coba ubah kata kunci pencarian',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAlumni = _getFilteredAlumni();
    final isInitialLoading = isLoading && filteredAlumni.isEmpty;
    final isLoadingMore = isLoading && filteredAlumni.isNotEmpty && !isLastPage;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchAlumni(refresh: true),
              color: const Color(0xFF5B913B),
              child: isInitialLoading
                  ? const LoadingScreen(
                      message: 'Memuat data Alumni...',
                      backgroundColor: Colors.teal,
                      progressColor: Colors.white,
                      icon: Icons.history_edu,
                    )
                  : filteredAlumni.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(top: 8, bottom: 20),
                          itemCount: filteredAlumni.length + (isLoadingMore ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index >= filteredAlumni.length) {
                              return LoadingScreen(
                                message: 'Memuat data Alumni...',
                                backgroundColor: Colors.teal,
                                progressColor: Colors.white,
                                icon: Icons.history_edu,
                              ); 
                            }
                            return _buildAlumniCard(filteredAlumni[index], index);
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}