import 'package:flutter/material.dart';
import '../../controllers/auth_controller.dart';
import '../../models/user_model.dart';
import 'login_bottomsheet.dart';

class RegisterBottomSheet extends StatefulWidget {
  @override
  _RegisterBottomSheetState createState() => _RegisterBottomSheetState();
}

class _RegisterBottomSheetState extends State<RegisterBottomSheet> {
  final AuthController _authController = AuthController();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  
  final Color primaryColor = const Color(0xFF11B3CF);
  bool _isPasswordObscure = true;
  bool _isConfirmPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => LoginBottomSheet(),
                    );
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "Register",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Full Name
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) =>
                value == null || value.isEmpty ? "Nama wajib diisi" : null,
            ),
            const SizedBox(height: 12),
            
            // Email
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty)
                  return "Email wajib diisi";
                if (!value.contains("@")) return "Email tidak valid";
                return null;
              },
            ),
            const SizedBox(height: 12),
            
            // Password
            TextFormField(
              controller: _passwordController,
              obscureText: _isPasswordObscure,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: primaryColor,
                  ),
                  onPressed: () => setState(
                      () => _isPasswordObscure = !_isPasswordObscure),
                ),
              ),
              validator: (value) => value == null || value.length < 6
                  ? "Password minimal 6 karakter"
                  : null,
            ),
            const SizedBox(height: 12),
            
            // Confirm Password
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _isConfirmPasswordObscure,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isConfirmPasswordObscure
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: primaryColor,
                  ),
                  onPressed: () => setState(() =>
                      _isConfirmPasswordObscure = !_isConfirmPasswordObscure),
                ),
              ),
              validator: (value) {
                if (value != _passwordController.text) {
                  return "Konfirmasi password tidak sama";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Register Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final user = User(
                      name: _nameController.text.trim(),
                      email: _emailController.text.trim(),
                      password: _passwordController.text,
                    );

                    _authController.register(
                      user,
                      _confirmPasswordController.text,
                      context,
                      onSuccess: () {
                        Navigator.pop(context); // Close register screen
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => LoginBottomSheet(),
                        );
                      },
                    );
                  }
                },
                child: const Text(
                  "Register",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}