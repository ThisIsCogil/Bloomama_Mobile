import 'package:flutter/material.dart';

class MentorScreen extends StatelessWidget {
  final ScrollController scrollController;

  MentorScreen({required this.scrollController});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7), // Ganti warna dengan kode hex
      body: Center(
        child: Text('Mentor Page', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}
