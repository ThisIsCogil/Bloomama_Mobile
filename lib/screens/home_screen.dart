import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7), // Ganti warna dengan kode hex
      body: Center(
        child: Text('Home Page', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
