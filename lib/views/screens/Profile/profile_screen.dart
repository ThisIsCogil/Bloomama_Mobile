import 'package:flutter/material.dart';
import 'package:login/views/auth_screen.dart';
import 'package:login/views/screens/Profile/edit.dart';
import 'package:login/views/screens/Profile/help.dart';
import 'package:login/views/screens/Profile/keamanan.dart';
import 'package:login/controllers/auth_controller.dart';
import 'package:login/models/user_model.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  final ScrollController scrollController;
  
  const ProfileScreen({Key? key, required this.scrollController}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthController _authController = AuthController();
  User? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await _authController.getUser();
    if (mounted) {
      setState(() {
        _user = user;
        _isLoading = false;
      });
    }
  }

  void _refreshUserData(User updatedUser) {
    if (mounted) {
      setState(() {
        _user = updatedUser;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: const Color(0xFF11B3CF),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: _user?.profilePicture != null
                              ? NetworkImage(_user!.profilePicture!)
                              : const AssetImage('assets/profile_pic.png') as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _user?.name ?? "Nama Pengguna",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _user?.email ?? "email@example.com",
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Chip(
                          label: const Text("Aktif"),
                          backgroundColor: Colors.green[100],
                          labelStyle: TextStyle(color: Colors.green[800]),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMenuItem(context, "Edit Profil", Icons.edit, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          user: _user,
                          onUserUpdated: _refreshUserData,
                        ),
                      ),
                    );
                  }),
                  _buildMenuItem(context, "Keamanan Akun", Icons.lock, SecurityScreen()),
                  _buildMenuItem(context, "Pusat Bantuan", Icons.help, HelpScreen()),
                  const SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      _authController.logout(context);
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(width: 8),
                        Text(
                          "LOGOUT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildMenuItem(BuildContext context, String title, IconData icon, dynamic page) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF11B3CF)),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          if (page is Widget) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => page),
            );
          } else if (page is Function) {
            page();
          }
        },
      ),
    );
  }
}