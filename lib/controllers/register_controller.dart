import 'package:flutter/material.dart';

class RegisterController {
  final TextEditingController fullNameController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  RegisterController({
    required this.fullNameController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
  });

  void handleRegister(BuildContext context) {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    print('Full Name: $fullName');
    print('Username: $username');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password & Confirm Password tidak cocok')),
      );
      return;
    }

    // TODO: Tambahkan API Call di sini nanti

    Navigator.pop(context); // Balik ke Login setelah sukses daftar
  }
}
