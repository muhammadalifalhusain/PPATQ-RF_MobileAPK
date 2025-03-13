import 'package:flutter/material.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/logo.png', height: 50),
        Text('PPATQ RAUDLATUL FALAH', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Text('Copyright © 2025 All Rights Reserved', style: TextStyle(fontSize: 14, color: Colors.black54)),
        SizedBox(height: 10),
      ],
    );
  }
}
