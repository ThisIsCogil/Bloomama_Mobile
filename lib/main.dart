import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'views/onboarding_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashSequence(
        child: OnboardingScreen(),
      ),
    );
  }
}


class SplashSequence extends StatefulWidget {
  final Widget child;
  
  const SplashSequence({Key? key, required this.child}) : super(key: key);

  @override
  _SplashSequenceState createState() => _SplashSequenceState();
}

class _SplashSequenceState extends State<SplashSequence> with TickerProviderStateMixin {
  late AnimationController _firstWaveController;
  late AnimationController _secondWaveController;
  late AnimationController _thirdWaveController;
  late AnimationController _fourthWaveController;
  late AnimationController _logoController;
  
  late Animation<double> _firstWaveAnimation;
  late Animation<double> _secondWaveAnimation;
  late Animation<double> _thirdWaveAnimation;
  late Animation<double> _fourthWaveAnimation;
  late Animation<double> _logoAnimation;
  
  bool _showFirstWave = true;
  bool _showSecondWave = false;
  bool _showLogo = false;
  bool _showThirdWave = false;
  bool _showFourthWave = false;

  
  final Color customBlueColor = const Color(0xFF11B3CF);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAnimationSequence();
    });
  }

  void _initializeAnimations() {
    // First wave - Slide up to reveal blue (from bottom to top)
    _firstWaveController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _firstWaveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _firstWaveController,
        curve: Curves.easeOutQuint,
      ),
    );

    // Second wave - Slide up to reveal white (from bottom to top like first wave)
    _secondWaveController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _secondWaveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _secondWaveController,
        curve: Curves.easeOutQuint,
      ),
    );

    // Logo animation
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Third wave - Slide down to reveal blue (from top to bottom)
    _thirdWaveController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _thirdWaveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _thirdWaveController,
        curve: Curves.easeOutQuint,
      ),
    );
  
    // Fourth wave - Slide down to reveal white (from top to bottom like third wave)
    _fourthWaveController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fourthWaveAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fourthWaveController,
        curve: Curves.easeOutQuint,
      ),
    );
  }

  void _startAnimationSequence() async {
    try {
      // Initial state
      setState(() {
        _showFirstWave = true;
        _showSecondWave = false;
        _showLogo = false;
        _showThirdWave = false;
        _showFourthWave = false;
      });

      // First wave animation (blue dari bawah)
      await _firstWaveController.forward();
      
      // Second wave animation (white dari bawah) - slight delay for smoother transition
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _showSecondWave = true;
      });
      await _secondWaveController.forward();
      
      // Hide first wave after second completes
      setState(() {
        _showFirstWave = false;
      });
      
      // Transition to logo with small delay
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _showSecondWave = false;
        _showLogo = true;
      });

      // Logo animation
      await _logoController.forward();
      await Future.delayed(const Duration(milliseconds: 1800));
      await _logoController.reverse();
      
      // Transition to third wave
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _showLogo = false;
        _showThirdWave = true;
      });

      // Third wave animation (blue dari atas)
      await _thirdWaveController.forward();
      
      // Fourth wave animation (white dari atas) - slight delay
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() {
        _showFourthWave = true;
      });
      await _fourthWaveController.forward();
      
      // Hide third wave after fourth completes
      setState(() {
        _showThirdWave = false;
      });
      
      // Final transition
      await Future.delayed(const Duration(milliseconds: 150));
      setState(() {
        _showFourthWave = false;
      });

      // Navigate after all animations complete
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => widget.child),
        );
      }
    } catch (e) {
      debugPrint('Animation error: $e');
    }
  }

  @override
  void dispose() {
    _firstWaveController.dispose();
    _secondWaveController.dispose();
    _thirdWaveController.dispose();
    _fourthWaveController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: customBlueColor,
      body: Stack(
        children: [
          // Background color
          Container(color: Colors.white),
          
          // First wave - Slide up from bottom to reveal blue
          if (_showFirstWave)
            AnimatedBuilder(
              animation: _firstWaveAnimation,
              builder: (context, child) {
                return ClipPath(
                  clipper: WaveClipper(_firstWaveAnimation, direction: 'bottom-up', overshootPercentage: 0.2,),
                  child: Container(
                    color: customBlueColor,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                );
              },
            ),

          // Second wave - Slide up from bottom to reveal white
          if (_showSecondWave)
            AnimatedBuilder(
              animation: _secondWaveAnimation,
              builder: (context, child) {
                return ClipPath(
                  clipper: WaveClipper(_secondWaveAnimation, direction: 'bottom-up'),
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                );
              },
            ),

          // Logo
          if (_showLogo)
            Center(
              child: AnimatedBuilder(
                animation: _logoAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _logoAnimation.value,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 200,
                      height: 200,
                    ),
                  );
                },
              ),
            ),

          // Third wave - Slide down to reveal blue
          if (_showThirdWave)
            AnimatedBuilder(
              animation: _thirdWaveAnimation,
              builder: (context, child) {
                return ClipPath(
                  clipper: WaveClipper(_thirdWaveAnimation, direction: 'down'),
                  child: Container(
                    color: customBlueColor,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                );
              },
            ),

          // Fourth wave - Slide down from top to reveal white
          if (_showFourthWave)
            AnimatedBuilder(
              animation: _fourthWaveAnimation,
              builder: (context, child) {
                return ClipPath(
                  clipper: WaveClipper(_fourthWaveAnimation, direction: 'down'),
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final Animation<double> animation;
  final String direction;
  final double overshootPercentage;

  WaveClipper(this.animation, {
    required this.direction,
    this.overshootPercentage = 0.2, // Default overshoot 20%
  });

  @override
  Path getClip(Size size) {
    var path = Path();
    final animationValue = animation.value;
    final waveHeight = 80.0; // Lebih tinggi untuk gelombang yang lebih jelas
    
    // Hitung posisi dengan overshoot
    double calculatePosition(double value) {
      if (value < 0.5) {
        // Naik melebihi target (overshoot)
        return size.height * (1 - value * (1 + overshootPercentage));
      } else {
        // Kembali ke target (settle)
        double overshootValue = 0.5 * (1 + overshootPercentage);
        double settleProgress = (value - 0.5) / 0.5;
        return size.height * (1 - overshootValue + (overshootValue - 1) * settleProgress);
      }
    }

    if (direction == 'up') {
      // Wave dari atas ke bawah
    path.lineTo(0, calculatePosition(animationValue));
      
      var firstControlPoint = Offset(size.width / 4, size.height * (1 - animationValue) - waveHeight);
      var firstEndPoint = Offset(size.width / 2, size.height * (1 - animationValue));
      path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, 
        firstEndPoint.dx, firstEndPoint.dy,
      );

      var secondControlPoint = Offset(size.width * 3/4, size.height * (1 - animationValue) + waveHeight);
      var secondEndPoint = Offset(size.width, size.height * (1 - animationValue));
      path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, 
        secondEndPoint.dx, secondEndPoint.dy,
      );

      path.lineTo(size.width, 0);
    } else if (direction == 'down') {
      // Wave dari atas ke bawah
      path.moveTo(0, 0);
      path.lineTo(0, size.height * animationValue);
      
      var firstControlPoint = Offset(size.width / 4, size.height * animationValue - waveHeight);
      var firstEndPoint = Offset(size.width / 2, size.height * animationValue);
      path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, 
        firstEndPoint.dx, firstEndPoint.dy,
      );

      var secondControlPoint = Offset(size.width * 3/4, size.height * animationValue + waveHeight);
      var secondEndPoint = Offset(size.width, size.height * animationValue);
      path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, 
        secondEndPoint.dx, secondEndPoint.dy,
      );

      path.lineTo(size.width, 0);
    } else if (direction == 'bottom-up') {
      // Wave dari bawah ke atas
      path.moveTo(0, size.height);
      path.lineTo(0, size.height * (1 - animationValue));
      
      var firstControlPoint = Offset(size.width / 4, size.height * (1 - animationValue) - waveHeight);
      var firstEndPoint = Offset(size.width / 2, size.height * (1 - animationValue));
      path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, 
        firstEndPoint.dx, firstEndPoint.dy,
      );

      var secondControlPoint = Offset(size.width * 3/4, size.height * (1 - animationValue) + waveHeight);
      var secondEndPoint = Offset(size.width, size.height * (1 - animationValue));
      path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, 
        secondEndPoint.dx, secondEndPoint.dy,
      );

      path.lineTo(size.width, size.height);
    }
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}