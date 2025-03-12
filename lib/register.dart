import 'package:flutter/material.dart';
import 'login.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFF2F4F7),
      body: Stack(
        children: [
          CustomPaint(
            size: Size(MediaQuery.of(context).size.width, 250),
            painter: HeaderPainter(),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Daftar",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "Rawat Si-Bayi Mulai Dari Sekarang!",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildTextField('Full Name', Icons.contacts),
                          const SizedBox(height: 10),
                          _buildTextField('Username', Icons.person),
                          const SizedBox(height: 10),
                          const PasswordTextField(),
                          const SizedBox(height: 10),
                          const PasswordTextField(label: 'Confirm Password'),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: const Color(0xFF11B3CF),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()),
                                );
                              },
                              child: const Text(
                                "Register",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginScreen()),
                                );
                              },
                              child: const Text(
                                "Sudah mempunyai akun? Klik disini",
                                style: TextStyle(color: Color(0xFF11B3CF)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFF11B3CF)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
          prefixIcon: Icon(icon, color: const Color(0xFF11B3CF)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF11B3CF), width: 2.0),
          ),
        ),
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String label;
  const PasswordTextField({super.key, this.label = 'Password'});

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextFormField(
        obscureText: _obscureText,
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.grey),
          floatingLabelStyle: const TextStyle(color: Color(0xFF11B3CF)),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12)),
          prefixIcon: const Icon(Icons.lock, color: Color(0xFF11B3CF)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF11B3CF), width: 2.0),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
        ),
      ),
    );
  }
}
