import 'package:flutter/material.dart';
import 'package:login/screens/Profile/edit.dart';
import 'package:login/screens/Profile/help.dart';
import 'package:login/screens/Profile/keamanan.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/profile_pic.png'), // Ganti dengan gambar yang sesuai
                  ),
                  SizedBox(height: 10),
                  Text("Retno Dwi Astuti", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text("Aktif", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildMenuItem(context, "Edit Profil", Icons.edit, EditProfileScreen()),
            _buildMenuItem(context, "Keamanan Akun", Icons.lock, SecurityScreen()),
            _buildMenuItem(context, "Pusat Bantuan", Icons.help, HelpScreen()),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Tambahkan fungsi logout di sini
              },
              child: Text("LOGOUT", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, Widget page) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
    );
  }
}
