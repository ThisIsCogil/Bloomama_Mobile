import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool showStrengthMeter;
  final String? helperText;

  const PasswordTextField({
    super.key,
    required this.controller,
    this.label = 'Password',
    this.showStrengthMeter = false,
    this.helperText,
  });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  double _strength = 0;

  void _checkPasswordStrength(String password) {
    if (!widget.showStrengthMeter) return;

    double strength = 0;
    if (password.isEmpty) {
      strength = 0;
    } else if (password.length < 6) {
      strength = 0.25;
    } else if (password.length < 8) {
      strength = 0.5;
    } else {
      strength = 1.0;
    }

    setState(() {
      _strength = strength;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            onChanged: _checkPasswordStrength,
            decoration: InputDecoration(
              labelText: widget.label,
              helperText: widget.helperText,
              labelStyle: const TextStyle(color: Colors.grey),
              floatingLabelStyle: const TextStyle(color: Color(0xFF11B3CF)),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
              prefixIcon:
                  const Icon(Icons.lock, color: Color(0xFF11B3CF)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF11B3CF), width: 2.0),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons.visibility_off
                      : Icons.visibility,
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
        ),
        if (widget.showStrengthMeter)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: LinearProgressIndicator(
              value: _strength,
              backgroundColor: Colors.grey[300],
              color: _strength <= 0.25
                  ? Colors.red
                  : _strength <= 0.5
                      ? Colors.orange
                      : Colors.green,
              minHeight: 5,
            ),
          ),
      ],
    );
  }
}
