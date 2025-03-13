import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(radius: 50, backgroundImage: AssetImage('assets/profile_pic.png')),
            SizedBox(height: 10),
            _buildTextField("Nama Lengkap", "Retno Dwi Astuti"),
            _buildTextField("Tempat & Tgl Lahir", "Jember, 26 Februari 1978"),
            _buildTextField("Alamat", "Jalan Nasional 03, Jember, Jawa Timur"),
            _buildTextField("No Telepon", "08123456781212"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan fungsi simpan data di sini
              },
              child: Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
