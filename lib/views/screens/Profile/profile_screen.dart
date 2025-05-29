import 'package:flutter/material.dart';
import 'package:login/views/screens/Profile/edit.dart';
import 'package:login/views/screens/Profile/help.dart';
import 'package:login/views/screens/Profile/keamanan.dart';
import 'package:login/controllers/auth_controller.dart';
import 'package:login/models/user_model.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/services.dart';

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
    // Get screen size for responsive layout
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 360;
    final bool isTablet = screenSize.width >= 600;
    
    // Calculate the minimum screen height required for all content
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    // Minimum height ensures scrolling works even on larger screens
    final double minContentHeight = screenSize.height + 100;
    
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: minContentHeight,
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        children: [
                          _buildProfileHeader(isSmallScreen, isTablet),
                          SizedBox(height: isTablet ? 32 : 24),
                          _buildMenuItems(isTablet),
                          SizedBox(height: isTablet ? 32 : 24),
                          _buildLogoutButton(isTablet),
                          // Add extra padding at bottom to ensure the logout button 
                          // is visible above the navigation bar
                          SizedBox(height: bottomPadding + (isTablet ? 80 : 64)),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildProfileHeader(bool isSmallScreen, bool isTablet) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    // Calculate profile picture radius based on screen width
    final double pictureRadius = isTablet ? 70 : (isSmallScreen ? 40 : 50);
    final double statusIndicatorRadius = isTablet ? 8 : (isSmallScreen ? 4 : 6);
    
    return Container(
      padding: EdgeInsets.fromLTRB(
        16, 
        statusBarHeight + (isTablet ? 24 : 16), 
        16, 
        isTablet ? 48 : 32
      ),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A11B3CF),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Title
          Padding(
            padding: EdgeInsets.only(bottom: isTablet ? 32 : 24),
            child: Text(
              'Profil',
              style: TextStyle(
                fontSize: isTablet ? 28 : (isSmallScreen ? 20 : 22),
                fontWeight: FontWeight.w600,
                color: const Color(0xFF11B3CF),
              ),
            ),
          ),
          
          // Tablet Layout - Horizontal arrangement for profile info
          if (isTablet)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with Status Indicator
                _buildProfilePicture(pictureRadius, statusIndicatorRadius),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Name
                      Text(
                        _user?.name ?? "Nama Pengguna",
                        style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // User Email
                      Text(
                        _user?.email ?? "email@example.com",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Status Badge
                      _buildStatusBadge(isTablet),
                    ],
                  ),
                ),
              ],
            )
          else
            // Mobile Layout - Vertical arrangement
            Column(
              children: [
                // Profile Picture with Status Indicator
                _buildProfilePicture(pictureRadius, statusIndicatorRadius),
                SizedBox(height: isSmallScreen ? 12 : 16),
                // User Name
                Text(
                  _user?.name ?? "Nama Pengguna",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 20 : 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 2 : 4),
                // User Email
                Text(
                  _user?.email ?? "email@example.com",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: isSmallScreen ? 8 : 12),
                // Status Badge
                _buildStatusBadge(isTablet),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProfilePicture(double radius, double statusIndicatorRadius) {
    return Stack(
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
            radius: radius,
            backgroundColor: Colors.grey[200],
            backgroundImage: _user?.profilePicture != null
                ? NetworkImage(_user!.profilePicture!)
                : const AssetImage('assets/logo.png') as ImageProvider,
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
          child: CircleAvatar(
            radius: statusIndicatorRadius,
            backgroundColor: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(bool isTablet) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 16 : 12, 
        vertical: isTablet ? 8 : 6
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF11B3CF).withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF11B3CF).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: isTablet ? 5 : 4,
            backgroundColor: const Color(0xFF11B3CF),
          ),
          SizedBox(width: isTablet ? 8 : 6),
          Text(
            "Aktif",
            style: TextStyle(
              color: const Color(0xFF11B3CF),
              fontWeight: FontWeight.w500,
              fontSize: isTablet ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(bool isTablet) {
    // For tablet, we can use a wider max width but center the container
    double maxWidth = isTablet ? 500 : double.infinity;
    
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
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
            isTablet: isTablet,
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
          _buildDivider(isTablet),
          _buildMenuItem(
            context: context,
            title: "Keamanan Akun",
            icon: Icons.shield_outlined,
            isTablet: isTablet,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SecurityScreen()),
            ),
          ),
          _buildDivider(isTablet),
          _buildMenuItem(
            context: context,
            title: "Pusat Bantuan",
            icon: Icons.help_outline,
            isTablet: isTablet,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(left: isTablet ? 72 : 56),
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
    required bool isTablet,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: const Color(0xFF11B3CF).withOpacity(0.1),
      highlightColor: const Color(0xFF11B3CF).withOpacity(0.05),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 : 16, 
          vertical: isTablet ? 18 : 14
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isTablet ? 10 : 8),
              decoration: BoxDecoration(
                color: const Color(0xFF11B3CF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(isTablet ? 12 : 10),
              ),
              child: Icon(
                icon,
                color: const Color(0xFF11B3CF),
                size: isTablet ? 24 : 22,
              ),
            ),
            SizedBox(width: isTablet ? 20 : 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: const Color(0xFF11B3CF),
              size: isTablet ? 18 : 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(bool isTablet) {
    // For tablet, we can use a wider max width but centered
    double maxWidth = isTablet ? 500 : double.infinity;
    
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _authController.logout(context),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: isTablet ? 18 : 16),
          backgroundColor: const Color(0xFF11B3CF),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isTablet ? 16 : 12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: isTablet ? 22 : 20,
            ),
            SizedBox(width: isTablet ? 10 : 8),
            Text(
              "Keluar",
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
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