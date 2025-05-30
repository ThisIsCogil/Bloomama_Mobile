import 'package:flutter/material.dart';
import 'package:login/models/user_model.dart';
import 'package:login/controllers/auth_controller.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  final User user;
  final Function(User)? onProfileUpdated;
  
  const EditProfileScreen({
    Key? key,
    required this.user,
    this.onProfileUpdated,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  final ImagePicker _picker = ImagePicker();
  
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _profilePicture;
  File? _selectedImageFile;
  bool _isImageChanged = false;
  
  // Warna tema utama
  final Color _themeColor = const Color(0xFF11B3CF);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phoneNumber ?? '');
    _addressController = TextEditingController(text: widget.user.address ?? '');
    _profilePicture = widget.user.profilePicture;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: _themeColor,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_rounded),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 32),
              _buildNameField(),
              const SizedBox(height: 20),
              _buildEmailField(),
              const SizedBox(height: 20),
              _buildPhoneField(),
              const SizedBox(height: 20),
              _buildAddressField(),
              const SizedBox(height: 40),
              _buildSaveButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return GestureDetector(
      onTap: _showImageSourceDialog,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: _themeColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey[200],
              backgroundImage: _getProfileImage(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _themeColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _themeColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  ImageProvider _getProfileImage() {
    if (_selectedImageFile != null) {
      return FileImage(_selectedImageFile!);
    } else if (_profilePicture != null && _profilePicture!.isNotEmpty) {
      // Jika profile picture adalah URL lengkap, gunakan NetworkImage
      if (_profilePicture!.startsWith('http')) {
        return NetworkImage(_profilePicture!);
      }
      // Jika hanya path, kombinasikan dengan base URL
      return NetworkImage('${AuthController.baseUrl}/storage/$_profilePicture');
    } else {
      return const AssetImage('assets/logo.png');
    }
  }

  Widget _buildNameField() {
    return _buildTextField(
      controller: _nameController,
      label: 'Nama Lengkap',
      icon: Icons.person_outline_rounded,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return _buildTextField(
      initialValue: widget.user.email,
      label: 'Email',
      icon: Icons.email_outlined,
      readOnly: true,
    );
  }

  Widget _buildPhoneField() {
    return _buildTextField(
      controller: _phoneController,
      label: 'Nomor Telepon',
      icon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildAddressField() {
    return _buildTextField(
      controller: _addressController,
      label: 'Alamat',
      icon: Icons.location_on_outlined,
      maxLines: 3,
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? initialValue,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey.shade600),
          prefixIcon: Icon(icon, color: _themeColor, size: 22),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: _themeColor, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
        style: const TextStyle(fontSize: 16),
        readOnly: readOnly,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: _themeColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: _themeColor.withOpacity(0.4),
        ),
        child: const Text(
          'SIMPAN PERUBAHAN',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Pilih Sumber Foto',
          style: TextStyle(color: _themeColor, fontWeight: FontWeight.w600),
          textAlign: TextAlign.center,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageSourceOption(
              icon: Icons.camera_alt_rounded,
              title: 'Kamera',
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            _buildImageSourceOption(
              icon: Icons.photo_library_rounded,
              title: 'Galeri',
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSourceOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _themeColor, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
          _isImageChanged = true;
        });
        _showSnackBar('Foto berhasil diambil dari kamera', AnimatedSnackBarType.success);
      }
    } catch (e) {
      _showSnackBar('Gagal mengambil foto dari kamera: $e', AnimatedSnackBarType.error);
    }
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImageFile = File(pickedFile.path);
          _isImageChanged = true;
        });
        _showSnackBar('Foto berhasil dipilih dari galeri', AnimatedSnackBarType.success);
      }
    } catch (e) {
      _showSnackBar('Gagal memilih foto dari galeri: $e', AnimatedSnackBarType.error);
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _authController.updateProfile(
        context: context,
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        profileImageFile: _isImageChanged ? _selectedImageFile : null,
        onSuccess: () {
          final updatedUser = widget.user.copyWith(
            name: _nameController.text,
            phoneNumber: _phoneController.text,
            address: _addressController.text,
            profilePicture: _profilePicture,
          );
          
          widget.onProfileUpdated?.call(updatedUser);
          Navigator.pop(context);
        },
      );
    } catch (e) {
      _showSnackBar('Gagal memperbarui profil: $e', AnimatedSnackBarType.error);
    }
  }

  void _showSnackBar(String message, AnimatedSnackBarType type) {
    AnimatedSnackBar.material(
      message,
      type: type,
      duration: const Duration(seconds: 3),
    ).show(context);
  }
}