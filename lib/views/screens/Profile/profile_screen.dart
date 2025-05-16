import 'package:flutter/material.dart';
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
  State<ProfileScreen> createState() => _ProfileScreenState();
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
    try {
      final user = await _authController.getUser();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Gagal memuat data pengguna');
      }
    }
  }

  void _refreshUserData(User updatedUser) {
    if (mounted) {
      setState(() {
        _user = updatedUser;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    AnimatedSnackBar.material(
      message,
      type: AnimatedSnackBarType.error,
      duration: const Duration(seconds: 3),
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF11B3CF),
                strokeWidth: 3,
              ),
            )
          : RefreshIndicator(
              color: const Color(0xFF11B3CF),
              onRefresh: _loadUserData,
              child: SingleChildScrollView(
                controller: widget.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    _buildProfileHeader(),
                    const SizedBox(height: 24),
                    _buildMenuItems(),
                    const SizedBox(height: 24),
                    _buildLogoutButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader() {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    
    return Container(
      padding: EdgeInsets.fromLTRB(16, statusBarHeight + 16, 16, 32),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x1A11B3CF),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Title
          const Padding(
            padding: EdgeInsets.only(bottom: 24),
            child: Text(
              'Profil',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF11B3CF),
              ),
            ),
          ),
          // Profile Picture with Status Indicator
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF11B3CF), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: _user?.profilePicture != null
                      ? NetworkImage(_user!.profilePicture!)
                      : const AssetImage('assets/profile_pic.png') as ImageProvider,
                ),
              ),
              // Status indicator
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // User Name
          Text(
            _user?.name ?? "Nama Pengguna",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          // User Email
          Text(
            _user?.email ?? "email@example.com",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          // Status Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF11B3CF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: const Color(0xFF11B3CF).withOpacity(0.3),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: Color(0xFF11B3CF),
                ),
                SizedBox(width: 6),
                Text(
                  "Aktif",
                  style: TextStyle(
                    color: Color(0xFF11B3CF),
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF11B3CF).withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF11B3CF).withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context: context,
            title: "Edit Profil",
            icon: Icons.person_outline,
            onTap: () {
              if (_user != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProfileScreen(
                      user: _user!,
                      onProfileUpdated: _refreshUserData,
                    ),
                  ),
                );
              }
            },
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            title: "Keamanan Akun",
            icon: Icons.shield_outlined,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityScreen()),
            ),
          ),
          _buildDivider(),
          _buildMenuItem(
            context: context,
            title: "Pusat Bantuan",
            icon: Icons.help_outline,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 56),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: const Color(0xFF11B3CF).withOpacity(0.1),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0xFF11B3CF).withOpacity(0.1),
      highlightColor: const Color(0xFF11B3CF).withOpacity(0.05),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF11B3CF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF11B3CF),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF333333),
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF11B3CF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        onPressed: () => _authController.logout(context),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: const Color(0xFF11B3CF),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              "Keluar",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}