import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/midwife_model.dart';
import '../../../models/user_model.dart';
import '../../../services/api_service.dart';
import '../../../controllers/auth_controller.dart';
import 'mentor_screen.dart'; // Import MentorScreen

class MidwifeListScreen extends StatefulWidget {
  final ScrollController scrollController;
  
  const MidwifeListScreen({
    Key? key, 
    required this.scrollController,
  }) : super(key: key);

  @override
  State<MidwifeListScreen> createState() => _MidwifeListScreenState();
}

class _MidwifeListScreenState extends State<MidwifeListScreen> {
  List<MidwifeModel> midwives = [];
  bool isLoading = true;
  String errorMessage = '';
  User? currentUser;
  final AuthController _authController = AuthController();
  bool _isNavbarVisible = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
    
    // Listen to scroll changes to track navbar visibility
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final direction = widget.scrollController.position.userScrollDirection;
    if (direction == ScrollDirection.reverse) {
      if (_isNavbarVisible) {
        setState(() {
          _isNavbarVisible = false;
        });
      }
    } else if (direction == ScrollDirection.forward) {
      if (!_isNavbarVisible) {
        setState(() {
          _isNavbarVisible = true;
        });
      }
    }
  }

  Future<void> _initializeData() async {
    await _loadCurrentUser();
    await loadMidwives();
  }

  // PERBAIKAN: Method untuk load user dengan lebih robust
  Future<void> _loadCurrentUser() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Cek token terlebih dahulu
      final token = await _authController.getToken();
      print('Token found: ${token != null ? 'Yes' : 'No'}');
      
      if (token == null) {
        print('No token found, user not logged in');
        setState(() {
          currentUser = null;
        });
        return;
      }

      // Coba ambil data user terbaru dari server
      try {
        final serverUser = await ApiService.getUserProfile();
        if (serverUser != null) {
          print('User loaded from server: ${serverUser.name}');
          setState(() {
            currentUser = serverUser;
          });
          return;
        }
      } catch (e) {
        print('Failed to fetch user from server: $e');
      }

      // Fallback: ambil dari AuthController
      final localUser = await _authController.getUser();
      if (localUser != null) {
        print('User loaded from local storage: ${localUser.name}');
        setState(() {
          currentUser = localUser;
        });
      } else {
        print('No user data found');
        setState(() {
          currentUser = null;
        });
      }

    } catch (e) {
      print('Error loading current user: $e');
      setState(() {
        currentUser = null;
      });
    }
  }

  Future<void> loadMidwives() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final List<MidwifeModel> result = await ApiService.getAllMidwives();
      setState(() {
        isLoading = false;
        midwives = result;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    }
  }

  Future<void> openWhatsApp(String phoneNumber, String midwifeName) async {
    // Pastikan user data ter-load
    if (currentUser == null) {
      await _loadCurrentUser();
    }

    final formattedNumber = _formatPhoneNumber(phoneNumber);
    
    // Buat pesan dengan nama user yang login
    String message;
    if (currentUser != null && currentUser!.name.isNotEmpty) {
      message = Uri.encodeComponent(
        'Halo Bidan $midwifeName, saya ${currentUser!.name} ingin berkonsultasi.'
      );
      print('WhatsApp message will include user name: ${currentUser!.name}');
    } else {
      // Fallback jika user tidak ditemukan
      message = Uri.encodeComponent(
        'Halo Bidan $midwifeName, saya ingin berkonsultasi.'
      );
      print('WhatsApp message will use fallback (no user name)');
    }
    
    final whatsappUrl = 'https://wa.me/$formattedNumber?text=$message';
    
    try {
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        _showSnackBar('Tidak dapat membuka WhatsApp. Pastikan WhatsApp terinstall.');
      }
    } catch (e) {
      _showSnackBar('Error: ${e.toString()}');
    }
  }

  String _formatPhoneNumber(String phoneNumber) {
    String cleaned = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (cleaned.startsWith('0')) {
      cleaned = '62${cleaned.substring(1)}';
    }
    
    if (!cleaned.startsWith('62')) {
      cleaned = '62$cleaned';
    }
    
    return cleaned;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // Method untuk membuka MentorScreen
  void _openMentorScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MentorScreen(
          scrollController: ScrollController(), // Buat scroll controller baru untuk MentorScreen
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: CustomScrollView(
        controller: widget.scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Clean App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: Color(0xFF11B3CF),
            surfaceTintColor: Colors.transparent,
            shadowColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
              title: const Text(
                'Daftar Bidan',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16, bottom: 8),
                child: IconButton(
                  onPressed: () async {
                    await _loadCurrentUser(); // Refresh user data juga
                    await loadMidwives();
                  },
                  icon: const Icon(
                    Icons.refresh_rounded,
                    color: Color(0xFF6B7280),
                  ),
                  style: IconButton.styleFrom(
                    backgroundColor: const Color(0xFFF3F4F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: _buildContent(),
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: 100),
          ),
        ],
      ),
      // Floating Action Button dengan posisi yang menyesuaikan navbar
      floatingActionButton: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          bottom: _isNavbarVisible ? 80 : 16, // Naik saat navbar visible, turun saat hidden
          right: 16,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF11B3CF).withOpacity(0.3),
                offset: const Offset(0, 4),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: _openMentorScreen,
            backgroundColor: const Color(0xFF11B3CF),
            foregroundColor: Colors.white,
            elevation: 0,
            highlightElevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              size: 28,
            ),
          ),
        ),
      ),

      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(
                  color: Color(0xFF11B3CF),
                  strokeWidth: 2.5,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Memuat data bidan...',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.error_outline_rounded,
                  size: 32,
                  color: Color(0xFFEF4444),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () async {
                  await _loadCurrentUser();
                  await loadMidwives();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11B3CF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Coba Lagi',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (midwives.isEmpty) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.people_outline_rounded,
                  size: 32,
                  color: Color(0xFF9CA3AF),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tidak ada data bidan',
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF374151),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Silakan coba lagi nanti',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF11B3CF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.local_hospital_rounded,
                  color: Color(0xFF11B3CF),
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${midwives.length} Bidan Tersedia',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // User status info - Show current user info
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: currentUser != null 
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: currentUser != null 
                    ? Colors.green.withOpacity(0.3)
                    : Colors.orange.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  currentUser != null ? Icons.check_circle : Icons.warning,
                  color: currentUser != null ? Colors.green : Colors.orange,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    currentUser != null 
                        ? 'Login sebagai: ${currentUser!.name}'
                        : 'Tidak dapat memuat data user',
                    style: TextStyle(
                      fontSize: 12,
                      color: currentUser != null ? Colors.green[700] : Colors.orange[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (currentUser == null)
                  TextButton(
                    onPressed: _loadCurrentUser,
                    child: Text(
                      'Refresh',
                      style: TextStyle(
                        color: Colors.orange[700],
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Midwives Grid - Increased spacing between cards
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: midwives.length,
            separatorBuilder: (context, index) => const SizedBox(height: 20),
            itemBuilder: (context, index) {
              final midwife = midwives[index];
              return MinimalistMidwifeCard(
                midwife: midwife,
                onWhatsAppTap: () => openWhatsApp(
                  midwife.phoneNumber,
                  midwife.name,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class MinimalistMidwifeCard extends StatelessWidget {
  final MidwifeModel midwife;
  final VoidCallback onWhatsAppTap;

  const MinimalistMidwifeCard({
    Key? key,
    required this.midwife,
    required this.onWhatsAppTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(14),
                image: midwife.profilePicture != null && 
                       midwife.profilePicture!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(midwife.profilePicture!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: midwife.profilePicture == null || 
                     midwife.profilePicture!.isEmpty
                  ? const Icon(
                      Icons.person_rounded,
                      size: 24,
                      color: Color(0xFF9CA3AF),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    midwife.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF111827),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  
                  // Operational Hours with blue background
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF11B3CF).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: 12,
                          color: Color(0xFF11B3CF),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          midwife.operationalHours,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF11B3CF),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(width: 16),
            
            // WhatsApp Button
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF22C55E),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onWhatsAppTap,
                  child: const Center(
                    child: FaIcon(
                      FontAwesomeIcons.whatsapp,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}