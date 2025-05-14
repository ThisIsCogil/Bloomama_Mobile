import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'login_bottomsheet.dart';
import '../widgets/wave_painters.dart';

class AuthScreen extends StatelessWidget {
  final Color primaryColor = const Color(0xFF11B3CF);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor,
                  primaryColor.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Wave painter
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.3,
            child: CustomPaint(
              painter: TopWavePainter(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: size.height * 0.6,
            child: CustomPaint(
              painter: BottomShapePainter(),
            ),
          ),

          // Circle decorations
          Positioned(
            top: -120,
            right: -100,
            child: _circleDecoration(250, Colors.white.withOpacity(0.1)),
          ),
          Positioned(
            bottom: -80,
            left: -100,
            child: _circleDecoration(200, Colors.white.withOpacity(0.1)),
          ),
          Positioned(
            top: size.height * 0.6,
            right: -40,
            child: _circleDecoration(120, Colors.white.withOpacity(0.05)),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    'Welcome To,',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Bloomama',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Start Your Pregnancy Journey From Now!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(flex: 1),
                  SizedBox(
                    width: 340,
                    height: 340,
                    child: Lottie.asset('assets/lottie/login.json',
                        fit: BoxFit.contain),
                  ),
                  const Spacer(flex: 1),
                  ElevatedButton(
                    onPressed: () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => LoginBottomSheet(),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Let\'s Start',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 8),
                        Icon(Icons.arrow_forward, color: primaryColor),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleDecoration(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}