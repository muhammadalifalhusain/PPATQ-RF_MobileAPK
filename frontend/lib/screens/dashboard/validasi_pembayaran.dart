import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import '../dashboard/riwayat_bayar_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ValidasiPembayaranScreen extends StatelessWidget {
  const ValidasiPembayaranScreen({super.key});

  Future<Map<String, String>> _getData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'noVa': prefs.getString('noVa') ?? '-',
      'nama': prefs.getString('nama') ?? '-',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        toolbarHeight: 56,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 32,color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            'Konfirmasi',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 8),

                    Text(
                      '" Lapor bukti bayar ini adalah Upaya memudahkan pemetaan data bayar sesuai dengan keperuntukannya sekaligus double check antara Lembaga pondok dengan wali santri "',
                      style:
                          GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight:
                            FontWeight.w600,
                      ),
                      textAlign:
                          TextAlign.center,
                    ),

                    const SizedBox(height: 14),

                    FutureBuilder<
                        Map<String, String>>(
                      future: _getData(),
                      builder:
                          (context, snapshot) {
                        if (snapshot
                                .connectionState ==
                            ConnectionState
                                .waiting) {
                          return Card(
                            margin:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            elevation: 3,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                            ),
                            child: const Padding(
                              padding:
                                  EdgeInsets
                                      .all(20),
                              child: Center(
                                child:
                                    CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }

                        if (!snapshot
                                .hasData ||
                            snapshot.data ==
                                null) {
                          return const SizedBox();
                        }

                        final data =
                            snapshot.data!;

                        final noVa =
                            data['noVa'] ??
                                '-';

                        final nama =
                            data['nama'] ??
                                '-';

                        final hasVaNumber =
                            noVa.isNotEmpty &&
                                noVa != '-';

                        return Card(
                          margin:
                              const EdgeInsets
                                  .symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          elevation: 4,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                          ),
                          child: Container(
                            decoration:
                                BoxDecoration(
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                12,
                              ),
                              gradient:
                                  LinearGradient(
                                colors: [
                                  Colors.blue
                                      .shade50,
                                  Colors.white
                                ],
                                begin:
                                    Alignment
                                        .topLeft,
                                end: Alignment
                                    .bottomRight,
                              ),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets
                                      .all(20),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons
                                            .payment,
                                        color: Colors
                                            .blue
                                            .shade700,
                                        size: 24,
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        'Informasi Pembayaran',
                                        style:
                                            GoogleFonts.poppins(
                                          fontSize:
                                              16,
                                          fontWeight:
                                              FontWeight.w700,
                                          color: Colors
                                              .blue
                                              .shade700,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(
                                      12,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors
                                              .white,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        8,
                                      ),
                                      border:
                                          Border.all(
                                        color: Colors
                                            .grey
                                            .shade200,
                                      ),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Icon(
                                          Icons
                                              .account_balance,
                                          color: Colors
                                              .green
                                              .shade600,
                                          size: 20,
                                        ),
                                        const SizedBox(
                                          width:
                                              12,
                                        ),
                                        Expanded(
                                          child:
                                              Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              Text(
                                                'Transfer ke Rekening BSI',
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontSize:
                                                      11,
                                                  fontWeight:
                                                      FontWeight.w600,
                                                ),
                                              ),
                                              const SizedBox(
                                                height:
                                                    2,
                                              ),
                                              Text(
                                                'a.n. Ponpes Anak Tahfidzul Qur\'an RF',
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontSize:
                                                      12,
                                                ),
                                              ),
                                              const SizedBox(
                                                height:
                                                    4,
                                              ),
                                              Text(
                                                '7141299818',
                                                style:
                                                    GoogleFonts.poppins(
                                                  fontSize:
                                                      16,
                                                  fontWeight:
                                                      FontWeight.w700,
                                                  color: Colors
                                                      .green
                                                      .shade800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed:
                                              () {
                                            Clipboard.setData(
                                              const ClipboardData(
                                                text:
                                                    '7141299818',
                                              ),
                                            );

                                            ScaffoldMessenger.of(
                                                    context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text(
                                                  'Nomor rekening disalin',
                                                ),
                                              ),
                                            );
                                          },
                                          icon:
                                              Icon(
                                            Icons
                                                .copy,
                                            color: Colors
                                                .grey
                                                .shade600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (hasVaNumber)
                                    ...[
                                      const SizedBox(
                                        height:
                                            10,
                                      ),
                                      Container(
                                        padding:
                                            const EdgeInsets
                                                .all(
                                          12,
                                        ),
                                        decoration:
                                            BoxDecoration(
                                          color: Colors
                                              .white,
                                          borderRadius:
                                              BorderRadius.circular(
                                            8,
                                          ),
                                          border:
                                              Border.all(
                                            color: Colors
                                                .grey
                                                .shade200,
                                          ),
                                        ),
                                        child:
                                            Row(
                                          children: [
                                            Icon(
                                              Icons
                                                  .credit_card,
                                              color: Colors
                                                  .orange
                                                  .shade600,
                                            ),
                                            const SizedBox(
                                              width:
                                                  12,
                                            ),
                                            Expanded(
                                              child:
                                                  Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'VA untuk $nama',
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize:
                                                          12,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height:
                                                        4,
                                                  ),
                                                  Text(
                                                    noVa,
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize:
                                                          16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.orange.shade700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            IconButton(
                                              onPressed:
                                                  () {
                                                Clipboard.setData(
                                                  ClipboardData(
                                                    text:
                                                        noVa,
                                                  ),
                                                );

                                                ScaffoldMessenger.of(
                                                        context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                    content:
                                                        Text(
                                                      'Nomor VA disalin',
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon:
                                                  Icon(
                                                Icons
                                                    .copy,
                                                color: Colors
                                                    .grey
                                                    .shade600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(
                                      10,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .amber
                                          .shade50,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        8,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .info_outline,
                                          size: 18,
                                          color: Colors
                                              .amber
                                              .shade700,
                                        ),
                                        const SizedBox(
                                          width:
                                              8,
                                        ),
                                        Expanded(
                                          child:
                                              Text(
                                            'Pastikan pembayaran sesuai nominal yang tertera',
                                            style:
                                                GoogleFonts.poppins(
                                              fontSize:
                                                  11,
                                              color: Colors
                                                  .amber
                                                  .shade800,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 24,
                top: 8,
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style:
                          OutlinedButton.styleFrom(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          vertical: 14,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            12,
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) =>
                                    RiwayatPembayaranScreen(),
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            'Riwayat Pembayaran Pondok',
                            style: GoogleFonts.poppins(
                              fontWeight:
                                  FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.chevron_right_rounded,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  TextButton(
                    onPressed: () {
                      _showHelpDialog(
                        context,
                      );
                    },
                    child: Text(
                      'Butuh bantuan? Hubungi Admin',
                      style:
                          GoogleFonts.poppins(
                        color:
                            Colors.blue,
                        decoration:
                            TextDecoration
                                .underline,
                      ),
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

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Bantuan Pembayaran',
          style: GoogleFonts.poppins(),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tekan untuk lanjut ke WhatsApp :',
              style: GoogleFonts.poppins(),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12), 
              ),
              child: ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: Text(
                  'Telepon: +6287767572025',
                  style: GoogleFonts.poppins(
                    color: Colors.green[900], 
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () async {
                  final whatsappUrl = Uri.parse("https://wa.me/6287767572025");
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
                  } else {
                    throw 'Tidak dapat membuka WhatsApp';
                  }
                },
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Tutup',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
}