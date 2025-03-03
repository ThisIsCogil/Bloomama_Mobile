import 'package:flutter/material.dart';
import '../login.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
      body: Center(child: Text('Profile Page')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.logout, color: Colors.white),
      ),
    );
  }
}
