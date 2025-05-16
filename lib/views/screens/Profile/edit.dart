import 'package:flutter/material.dart';
import 'package:login/models/user_model.dart';
import 'package:login/controllers/auth_controller.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

class EditProfileScreen extends StatefulWidget {
  final User? user;
  final Function(User)? onUserUpdated;
  
  const EditProfileScreen({Key? key, this.user, this.onUserUpdated}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  
  // Controllers for text fields
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  
  @override
  void initState() {
    super.initState();
    // Initialize controllers with user data if available
    nameController = TextEditingController(text: widget.user?.name ?? "");
    phoneController = TextEditingController(text: widget.user?.phoneNumber ?? "");
    addressController = TextEditingController(text: widget.user?.address ?? "");
    emailController = TextEditingController(text: widget.user?.email ?? "");
  }
  
  @override
  void dispose() {
    // Clean up controllers
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: widget.user?.profilePicture != null
                    ? NetworkImage(widget.user!.profilePicture!)
                    : const AssetImage('assets/profile_pic.png') as ImageProvider,
              ),
              const SizedBox(height: 15),
              TextButton.icon(
                onPressed: () {
                  // Add image selection functionality
                  _showImageSourceDialog();
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Ubah Foto"),
              ),
              const SizedBox(height: 20),
              _buildTextFormField(
                "Nama Lengkap", 
                "Masukkan nama lengkap", 
                nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              _buildTextFormField(
                "Email", 
                "Masukkan email", 
                emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true, // Email biasanya tidak bisa diubah
              ),
              _buildTextFormField(
                "No Telepon", 
                "Masukkan nomor telepon", 
                phoneController,
                keyboardType: TextInputType.phone,
              ),
              _buildTextFormField(
                "Alamat", 
                "Masukkan alamat lengkap", 
                addressController,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF11B3CF),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "SIMPAN",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(
    String label, 
    String hint, 
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pilih Sumber Foto"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galeri"),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement gallery image picking
                _showSnackBar("Fitur dalam pengembangan", AnimatedSnackBarType.info);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Kamera"),
              onTap: () {
                Navigator.pop(context);
                // TODO: Implement camera image capture
                _showSnackBar("Fitur dalam pengembangan", AnimatedSnackBarType.info);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      // Create updated user model
      final updatedUser = widget.user?.copyWith(
        name: nameController.text,
        phoneNumber: phoneController.text,
        address: addressController.text,
      );
      
      if (updatedUser != null) {
        // Call the AuthController's updateProfile method
        await _authController.updateProfile(
          updatedUser, 
          context,
          onSuccess: () {
            // Properly call the onUserUpdated callback if it exists
            if (widget.onUserUpdated != null) {
              widget.onUserUpdated!(updatedUser);
            }
          },
        );
      } else {
        throw Exception("User data tidak ditemukan");
      }
    } catch (e) {
      _showSnackBar("Gagal memperbarui profil: ${e.toString()}", AnimatedSnackBarType.error);
    }
  }

  void _showSnackBar(String message, AnimatedSnackBarType type) {
    AnimatedSnackBar.material(
      message,
      type: type,
      duration: const Duration(seconds: 3),
      mobileSnackBarPosition: MobileSnackBarPosition.bottom,
      desktopSnackBarPosition: DesktopSnackBarPosition.bottomRight,
    ).show(context);
  }
}