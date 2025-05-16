import 'package:flutter/material.dart';
import 'package:login/models/user_model.dart';
import 'package:login/controllers/auth_controller.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';

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
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  String? _profilePicture;

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
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildProfilePicture(),
              const SizedBox(height: 20),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildEmailField(),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 16),
              _buildAddressField(),
              const SizedBox(height: 24),
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
          CircleAvatar(
            radius: 60,
            backgroundImage: _profilePicture != null
                ? NetworkImage(_profilePicture!)
                : const AssetImage('assets/logo.png') as ImageProvider,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.edit, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nama Lengkap',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      initialValue: widget.user.email,
      decoration: InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.email),
      ),
      readOnly: true,
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: _phoneController,
      decoration: InputDecoration(
        labelText: 'Nomor Telepon',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.phone),
      ),
      keyboardType: TextInputType.phone,
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      controller: _addressController,
      decoration: InputDecoration(
        labelText: 'Alamat',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.location_on),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSaveButton() {
  return SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: _submitForm,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: const Text('SIMPAN PERUBAHAN'),
    ),
  );
}

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Sumber Foto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Kamera'),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Galeri'),
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

  Future<void> _pickImageFromCamera() async {
    // TODO: Implement camera image capture
    _showSnackBar('Fitur kamera dalam pengembangan', AnimatedSnackBarType.info);
  }

  Future<void> _pickImageFromGallery() async {
    // TODO: Implement gallery image picking
    _showSnackBar('Fitur galeri dalam pengembangan', AnimatedSnackBarType.info);
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _authController.updateProfile(
        context: context,
        name: _nameController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
        profilePicture: _profilePicture,
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