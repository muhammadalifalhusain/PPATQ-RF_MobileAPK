import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../widgets/app_header.dart'; // Import header
import '../widgets/footer_widget.dart'; // Import footer

class AboutPage extends StatelessWidget {
  // Function untuk buka URL
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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Konten scrollable
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(top: constraints.maxHeight * 0.31), // Padding agar tidak ketimpa header
                    child: Column(
                      children: [
                        // Konten About
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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

                        // Deskripsi
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Pesantren PPATQ Raudlatul Falah ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          'berdiri di atas lahan yang luas dan asri, berlokasi di Pati, Jawa Tengah. Dikenal sebagai lembaga pendidikan Islam yang berfokus pada pembentukan generasi penghafal Al-Qur\'an, pesantren ini telah memberikan kontribusi signifikan dalam pembangunan sumber daya manusia di bidang keagamaan serta pengembangan ilmu pengetahuan, dengan tetap berpegang teguh kepada Al-Qur\'an dan as-Sunnah sebagai pedoman utama.',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 13),
                              RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    height: 1.5,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Jenjang pendidikan ',
                                    ),
                                    TextSpan(
                                      text: 'Pesantren PPATQ Raudlatul Falah ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(
                                      text:
                                          'mulai dari tingkat dasar hingga menengah, dengan fokus utama pada program tahfidzul Qur\'an. Kurikulum yang digunakan merupakan perpaduan antara Kurikulum Pendidikan Nasional dan Kurikulum Kepesantrenan.',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),

                        // Youtube Preview
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
                              Text(
                                '"Bersama QU", Komitmen untuk membangun sebuah komunitas yang dijiwai oleh nilai-nilai keimanan dan keislaman yang kokoh. '
                                'Visi ini mencerminkan tekad untuk bersama-sama menjalani kehidupan dengan bertaqwa kepada Allah, menjunjung tinggi nilai-nilai kesantunan dalam berinteraksi, '
                                'berjuang untuk kemajuan yang berkelanjutan, dan menghidupkan Al-Qur\'an sebagai pedoman utama dalam segala aspek kehidupan.',
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
                         SizedBox(height: 20),
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
                        SizedBox(height: 22),
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
                        color: Colors.white.withOpacity(0.5), // Transparan dan blur
                        child: AppHeader(
                          showBackButton: true,
                          showAuthButtons: true,
                        ), // Tetap menggunakan widget header yang sama
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
