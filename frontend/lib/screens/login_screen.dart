import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'register_screen.dart';
import 'landing_page.dart';
import 'kesehatan_screen.dart'; // Pastikan Anda sudah membuat KesehatanScreen
import '../services/api_service.dart';
import './dashboard/main.dart'; 

// import '../models/login_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController noIndukController = TextEditingController();
  final TextEditingController kodeController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  bool isLoading = false;

  Future<void> _login() async {
    setState(() {
      isLoading = true;
    });

    try {
      final noIndukText = noIndukController.text.trim();
      final kode = kodeController.text.trim();
      final password = passwordController.text.trim();

      // Validasi input
      if (noIndukText.isEmpty) {
        throw Exception('Nomor induk harus diisi');
      }

      final noInduk = int.tryParse(noIndukText);
      if (noInduk == null) {
        throw Exception('Nomor induk harus berupa angka');
      }

      if (kode.isEmpty) {
        throw Exception('Kode harus diisi');
      }

      if (password.isEmpty) {
        throw Exception('Password harus diisi');
      }

      // Panggil API Login
      final response = await apiService.loginSiswa(
        noInduk: noInduk,
        kode: kode,
        password: password,
      );

      // Simpan token & data user menggunakan SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', response.token);
      await prefs.setInt('user_id', response.id);
      await prefs.setString('user_name', response.nama);
      await prefs.setInt('no_induk', response.noInduk);
      await prefs.setString('kode', response.kode);

      // Navigasi ke KesehatanScreen setelah login sukses
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.green.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // AppBar custom berisi icon beranda
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.home, color: Colors.black, size: 30),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LandingPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo dan Nama Pondok
                      Image.asset(
                        'assets/images/logo.png',
                        height: 120,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'PPATQ RAUDLATUL FALAH',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade800,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Pondok Pesantren Anak-anak Tahfidzul Qur\'an Raudlatul Falah – Pati',
                        style: TextStyle(
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 30),

                      // Form Login
                      Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal.shade800,
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: noIndukController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'No Induk',
                                  prefixIcon: Icon(Icons.numbers, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              TextField(
                                controller: kodeController,
                                decoration: InputDecoration(
                                  labelText: 'Kode',
                                  prefixIcon: Icon(Icons.code, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              TextField(
                                controller: passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  prefixIcon: Icon(Icons.lock, color: Colors.black),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              isLoading
                                  ? CircularProgressIndicator()
                                  : ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 40, vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        'Login',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.white),
                                      ),
                                    ),
                              SizedBox(height: 20),
                              Divider(
                                color: Colors.grey.shade500,
                                thickness: 1,
                                height: 1,
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Didn't have an account? ",
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 14,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RegisterScreen()),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 4),
                                      child: Text(
                                        'Register here',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: FooterWidget(),
            ),
          ],
        ),
      ),
    );
  }
}

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'PPATQ RAUDLATUL FALAH',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Copyright © 2025 All Rights Reserved',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}