import 'package:flutter/material.dart';
import 'package:login/views/screens/Profile/edit.dart';
import 'package:login/views/screens/Profile/help.dart';
import 'package:login/views/screens/Profile/keamanan.dart';
import 'package:login/models/user_model.dart'; // Make sure to import your User model

class ProfileScreen extends StatelessWidget {
  // Add a user parameter to your ProfileScreen or get it from your state management
  final User currentUser; 
  
  const ProfileScreen({Key? key, required this.currentUser}) : super(key: key);

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
                    backgroundImage: AssetImage('assets/profile_pic.png'),
                  ),
                  SizedBox(height: 10),
                  Text(currentUser.name, // Use actual user data
                      style: TextStyle(color: Colors.white, 
                          fontSize: 18, 
                          fontWeight: FontWeight.bold)),
                  Text("Aktif", style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            SizedBox(height: 20),
            _buildMenuItem(
              context, 
              "Edit Profil", 
              Icons.edit, 
              EditProfileScreen(user: currentUser) // Pass user here
            ),
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
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        },
      ),
    );
  }
}