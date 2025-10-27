import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/about_model.dart';
import '../services/api_service.dart';
import '../widgets/footer_widget.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late Future<About> futureAbout;

  @override
  void initState() {
    super.initState();
    futureAbout = ApiService().fetchAbout();
  }

  void _launchYoutubeVideo(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      print('Tidak dapat membuka link YouTube');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String videoUrl = 'https://youtu.be/V_Q4hHxonGg';
    final String videoId = 'V_Q4hHxonGg';
    final String thumbnailUrl = 'https://img.youtube.com/vi/$videoId/0.jpg';

    return Scaffold(
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
            'PPATQ-RF ku',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 16,
                  right: 16,
                ),
                child: FutureBuilder<About>(
                  future: futureAbout,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData) {
                      return Center(child: Text('Data tidak tersedia.'));
                    }

                    final about = snapshot.data!;
                    final tentang = about.data.tentang;
                    final visi = about.data.visi;
                    final misi = about.data.misi;

                    return Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TENTANG PESANTREN',
                                style: TextStyle(
                                  fontSize: 27,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'PPATQ RAUDLATUL FALAH - PATI',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Html(
                          data: tentang,
                          style: {
                            "div": Style(
                              fontSize: FontSize(15),
                              textAlign: TextAlign.justify,
                            ),
                          },
                        ),
                        GestureDetector(
                          onTap: () => _launchYoutubeVideo(videoUrl),
                          child: Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              width: MediaQuery.of(context).size.width * 0.85,
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 5,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.network(
                                      thumbnailUrl,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Icon(
                                      Icons.play_circle_fill,
                                      size: 64,
                                      color: Colors.white.withOpacity(0.85),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30),

                        // VISI DAN MISI
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'VISI DAN MISI',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'PPATQ RAUDLATUL FALAH',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Gambar VISI
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://new.ppatq-rf.sch.id/img/visi1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Teks VISI
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'VISI',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 10),
                              Html(
                                data: visi,
                                style: {
                                  "div": Style(
                                    fontSize: FontSize(16),
                                    textAlign: TextAlign.justify,
                                  ),
                                },
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),

                        SizedBox(height: 20),

                        // Gambar MISI
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              'https://new.ppatq-rf.sch.id/img/misi1.jpg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),

                        // Teks MISI
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'MISI',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 10),
                              Html(
                                data: misi,
                                style: {
                                  "div": Style(
                                    fontSize: FontSize(16),
                                    textAlign: TextAlign.justify,
                                  ),
                                },
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),

                        SizedBox(height: 22),

                        // SEKAPUR SIRIH
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'SEKAPUR SIRIH',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                'PPATQ RAUDLATUL FALAH',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 35),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://new.ppatq-rf.sch.id/img/KH.-Djaelani.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'SAMBUTAN KETUA DEWAN PEMBINA YAYASAN RAUDLATUL FALAH',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'السلام عليكم ورحمة الله وبركاته الحمد لله رب العالمين والصلاة والسلام علي اشرف الانبياء والمر سلين وعلي اله وصحبه اجمعين . اما بعد',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Seorang seniman terkenal mengatakan bahwa anak adalah harta yang berharga, '
                                'begitu juga dalam puisi Khalil Gibran, anak merupakan putra putri yang hidup yang rindu pada diri sendiri, '
                                'yang jiwanya adalah penghuni rumah masa depan, yang kehidupannya terus berlangsung tiada henti. '
                                'Pohon yang baik dikenal lewat buahnya yang baik. Anak yang sholeh melambangkan sosok orang tua yang sholeh.\n\n'
                                'Oleh karena itu mempersiapkan kehidupan anak dengan sebaik-baiknya merupakan tugas mulia bagi orang tua dan Yayasan Raudlatul Falah '
                                'lewat Pondok Pesantren Anak-Anak Tahfidzul Qur’an siap mewujudkan, ikut mempersiapkan, mendorong dan menjadikan generasi-generasi yang sholeh, '
                                'generasi qur’ani, santun, maju dan kreatif. Akhir kata selaku Ketua Dewan Pembina kami ucapkan banyak terima kasih pada semua pihak yang terlibat '
                                'dan membantu kemajuan pondok ini.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'والسلام عليكم ورحمة الله وبركاته',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 35),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    'https://new.ppatq-rf.sch.id/img/abah-sohib.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'KH. Ahmad Djaelani, AH, S.Pd.I',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Misi kami adalah menghasilkan generasi yang hafal Al-Qur\'an dengan mutu yang unggul, '
                                'bukan hanya sekedar dalam hafalan, tetapi juga dalam pemahaman dan aplikasi nilai-nilai Al-Qur\'an dalam kehidupan sehari-hari. '
                                'Kami berkomitmen untuk mencetak generasi yang tidak hanya cemerlang dalam akademik, tetapi juga memiliki karakter yang terkait erat dengan ajaran Al-Qur\'an. '
                                'Kami bertekad untuk meningkatkan mutu imtaq (keimanan) dan iptek (ilmu pengetahuan dan teknologi) dalam pendidikan, '
                                'serta menegakkan ahlakul karimah sebagai landasan moral dan etika dalam bermasyarakat.',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  fontSize: 16,
                                  height: 1.5,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        FooterWidget(),
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
