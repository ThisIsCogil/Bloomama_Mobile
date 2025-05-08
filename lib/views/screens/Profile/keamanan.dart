import 'package:flutter/material.dart';

class SecurityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Keamanan Akun")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kata Sandi Saat Ini
            Text("Kata Sandi Saat Ini", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masukkan kata sandi saat ini",
              ),
            ),
            SizedBox(height: 15),

            // Kata Sandi Baru
            Text("Kata Sandi Baru", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Masukkan kata sandi baru",
              ),
            ),
            SizedBox(height: 15),

            // Konfirmasi Kata Sandi
            Text("Konfirmasi Kata Sandi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Konfirmasi kata sandi baru",
              ),
            ),
            SizedBox(height: 20),

            // Tombol Ubah Kata Sandi
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF11B3CF),
                foregroundColor: Colors.white,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text("Ubah Kata Sandi"),
            ),
          ],
        ),
      ),
    );
  }
}
