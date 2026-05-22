import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/berita_service.dart';
import '../models/berita_model.dart';
import '../widgets/app_header.dart';
import '../widgets/berita_slider.dart';
import '../widgets/capain_tahfidz.dart';
import '../widgets/menu_widget.dart';
import '../models/capaian_tahfidz_model.dart';
import '../services/capaian_tahfidz_service.dart';
import '../widgets/pendaftaran_santri_widget.dart';
import '../utils/pendaftaran_url.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() =>
      _LandingPageState();
}

class _LandingPageState
    extends State<LandingPage> {
  final BeritaService beritaService =
      BeritaService();

  final CapaianTahfidzService
      capaianService =
      CapaianTahfidzService();

  final ScrollController
      _scrollController =
      ScrollController();

  bool isScrolled = false;

  List<BeritaItem> beritaList = [];

  CapaianTahfidzResponse?
      capaianResponse;

  int currentPage = 1;
  bool isLoading = false;
  bool hasMore = true;

  late Future<
          CapaianTahfidzResponse?>
      _capaianFuture;

  @override
  void initState() {
    super.initState();

    _loadBerita();
    _capaianFuture =
        _loadCapaianTahfidz();

    _scrollController.addListener(() {
      final shouldScroll =
          _scrollController.offset >
              20;

      if (shouldScroll !=
          isScrolled) {
        setState(() {
          isScrolled =
              shouldScroll;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<
      CapaianTahfidzResponse?>
  _loadCapaianTahfidz() async {
    final result =
        await CapaianTahfidzService
            .fetchCapaianTahfidz();

    if (result != null) {
      setState(() {
        capaianResponse =
            result;
      });
    }

    return result;
  }

  Future<void> _loadBerita() async {
    if (isLoading || !hasMore) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response =
          await beritaService
              .fetchBerita(
        page: currentPage,
      );

      final newBerita =
          response.data.data;

      setState(() {
        currentPage++;
        beritaList
            .addAll(newBerita);

        hasMore = response
                .data
                .nextPageUrl !=
            null;
      });
    } catch (e) {
      debugPrint(
        'Gagal memuat berita: $e',
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(
      BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller:
                _scrollController,
            child: Column(
              children: [
                const SizedBox(
                  height: 60,
                ),

                EnhancedRegistrationCard(
                  onTap:
                      launchPSBUrl,
                ),

                const SizedBox(
                  height: 12,
                ),

                Text(
                  'Menu Cepat',
                  style:
                      GoogleFonts
                          .poppins(
                    color: Colors
                        .black,
                    fontWeight:
                        FontWeight
                            .bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                  height: 8,
                ),

                MenuIkonWidget(),

                const SizedBox(
                  height: 8,
                ),

                FutureBuilder<
                    CapaianTahfidzResponse?>(
                  future:
                      _capaianFuture,
                  builder: (
                    context,
                    snapshot,
                  ) {
                    if (snapshot
                            .connectionState ==
                        ConnectionState
                            .waiting) {
                      return const Padding(
                        padding:
                            EdgeInsets.all(
                                20),
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    if (snapshot
                        .hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style:
                              GoogleFonts.poppins(
                            color:
                                Colors
                                    .red,
                          ),
                        ),
                      );
                    }

                    if (!snapshot
                            .hasData ||
                        snapshot.data ==
                            null ||
                        snapshot
                                .data!
                                .data ==
                            null) {
                      return Center(
                        child: Text(
                          'Tidak ada data capaian tahfidz',
                          style:
                              GoogleFonts.poppins(),
                        ),
                      );
                    }

                    final data =
                        snapshot
                            .data!
                            .data!;

                    final capaianList =
                        data
                            .capaianCustom;

                    final terendah =
                        data
                            .terendah;

                    return Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .stretch,
                      children: [
                        ...capaianList
                            .map(
                          (
                            item,
                          ) =>
                              CapaianCard(
                            title:
                                'Capaian',
                            data:
                                item,
                          ),
                        ),

                        if (terendah !=
                            null)
                          Padding(
                            padding:
                                const EdgeInsets
                                    .only(
                              top:
                                  4,
                            ),
                            child:
                                CapaianCard(
                              title:
                                  'Terendah',
                              data:
                                  terendah,
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(
                  height: 14,
                ),

                if (beritaList
                    .isNotEmpty)
                  Padding(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal:
                          16,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Berita Pondok',
                          style:
                              GoogleFonts.poppins(
                            fontWeight:
                                FontWeight.bold,
                            fontSize:
                                16,
                            color:
                                Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                const SizedBox(
                  height: 10,
                ),

                if (beritaList
                    .isEmpty)
                  const Padding(
                    padding:
                        EdgeInsets.all(
                            16),
                    child:
                        CircularProgressIndicator(),
                  )
                else
                  BeritaScreen(
                    beritaList:
                        beritaList,
                    onReachEnd:
                        _loadBerita,
                  ),

                if (isLoading)
                  const Padding(
                    padding:
                        EdgeInsets.only(
                      top: 12,
                      bottom:
                          12,
                    ),
                    child:
                        CircularProgressIndicator(),
                  ),

                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              bottom: false,
              child: AppHeader(
                isScrolled:
                    isScrolled,
                showBackButton:
                    false,
              ),
            ),
          ),
        ],
      ),
      bottomSheet:
          IgnorePointer(
        child: DecoratedBox(
          decoration:
              const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(
                    0xFF00897B),
                blurRadius:
                    44,
                spreadRadius:
                    0,
                offset: Offset(
                    0,
                    -24),
              ),
              BoxShadow(
                color: Color(
                    0xFF388E3C),
                blurRadius:
                    44,
                spreadRadius:
                    0,
                offset: Offset(
                    0,
                    -24),
              ),
            ],
          ),
          child:
              const SizedBox(
            height: 4,
            width:
                double.infinity,
          ),
        ),
      ),
    );
  }
}