import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final Color? primaryColor;
  final bool showStrengthMeter;

  const PasswordTextField({
    Key? key,
    required this.controller,
    this.labelText = 'Password',
    this.primaryColor,
    this.showStrengthMeter = false,
  }) : super(key: key);

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  String _password = '';
  int _passwordStrength = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updatePasswordStrength);
    super.dispose();
  }

  void _updatePasswordStrength() {
    setState(() {
      _password = widget.controller.text;
      _passwordStrength = _calculatePasswordStrength(_password);
    });
  }

  int _calculatePasswordStrength(String password) {
    // Simple password strength calculation
    if (password.isEmpty) return 0;
    
    int strength = 0;
    
    // Length check
    if (password.length >= 8) strength++;
    
    // Contains uppercase
    if (password.contains(RegExp(r'[A-Z]'))) strength++;
    
    // Contains lowercase
    if (password.contains(RegExp(r'[a-z]'))) strength++;
    
    // Contains numbers
    if (password.contains(RegExp(r'[0-9]'))) strength++;
    
    // Contains special characters
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength++;
    
    return strength;
  }

  String _getPasswordStrengthText() {
    if (_password.isEmpty) return 'Enter password';
    if (_passwordStrength <= 2) return 'Weak';
    if (_passwordStrength <= 4) return 'Medium';
    return 'Strong';
  }

  Color _getPasswordStrengthColor() {
    if (_password.isEmpty) return Colors.grey;
    if (_passwordStrength <= 2) return Colors.red;
    if (_passwordStrength <= 4) return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.primaryColor ?? const Color(0xFF2196F3);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          obscureText: _obscureText,
          onChanged: (value) {
            setState(() {
              _password = value;
              _passwordStrength = _calculatePasswordStrength(value);
            });
          },
          decoration: InputDecoration(
            labelText: widget.labelText,
            labelStyle: TextStyle(color: Colors.grey.shade600),
            floatingLabelStyle: TextStyle(color: activeColor),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: activeColor, width: 2.0),
            ),
            fillColor: Colors.grey.shade100,
            filled: true,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey.shade600,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
          ),
        ),
        if (widget.showStrengthMeter && _password.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      _getPasswordStrengthText(),
                      style: TextStyle(
                        color: _getPasswordStrengthColor(),
                        fontSize: 12,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${_passwordStrength}/5',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                LinearProgressIndicator(
                  value: _passwordStrength / 5,
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(_getPasswordStrengthColor()),
                ),
              ],
            ),
          ),
      ],
    );
  }
}