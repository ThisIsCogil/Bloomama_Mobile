import 'package:flutter/material.dart';
import 'package:login/views/auth_screen.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> with SingleTickerProviderStateMixin {
  PageController _pageController = PageController();
  int _currentPage = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<Map<String, dynamic>> _slides = [
    {
      'title': 'Education Resource',
      'lottieFile': 'assets/lottie/1.json', // Changed from image to lottieFile
      'description': 'Aplikasi ini akan menyediakan pendidikan untuk membantu pengguna belajar tentang kesehatan ibu, termasuk artikel, video, dan podcast.'
    },
    {
      'title': 'Tracking Tools',
      'lottieFile': 'assets/lottie/2.json', // Changed from image to lottieFile
      'description': 'Aplikasi ini akan menyediakan alat pelacakan untuk membantu pengguna memantau kemajuan kehamilan mereka, termasuk pelacakan berat badan.'
    },
    {
      'title': 'Lifesaving App',
      'lottieFile': 'assets/lottie/3.json', // Changed from image to lottieFile
      'description': 'Aplikasi mobile yang menyelamatkan jiwa yang memantau kesehatan ibu hamil, memberikan bantuan darurat, dan menghubungkan pengguna ke bantuan medis saat komplikasi muncul.'
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );
    _animationController.forward();
    _pageController.addListener(() {
      if (_pageController.page?.round() != _currentPage) {
        _animationController.reset();
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F4F7),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _slides.length,
                itemBuilder: (context, index) {
                  return _buildOnboardingSlide(
                    title: _slides[index]['title'],
                    lottieFile: _slides[index]['lottieFile'], // Updated parameter
                    description: _slides[index]['description'],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => _buildDotIndicator(index),
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnboardingSlide({
    required String title,
    required String lottieFile, // Changed parameter from image to lottieFile
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              title,
              style: GoogleFonts.nanumPenScript(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF4D8D),
              ),
            ),
          ),
          SizedBox(height: 40),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Lottie.asset(
              lottieFile, // Using Lottie instead of Image.asset
              height: 250,
              width: 250,
              fit: BoxFit.contain,
              repeat: true, // Animation will loop
              reverse: false,
            ),
          ),
          SizedBox(height: 40),
          FadeTransition(
            opacity: _fadeAnimation,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: GoogleFonts.mitr(
                fontSize: 14,
                color: Colors.black87,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.0),
      width: 10.0,
      height: 10.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index
            ? Color(0xFF2BACE2)
            : Color(0xFFD8D8D8),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Back button (not visible on first slide)
            _currentPage > 0
                ? TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease,
                      );
                    },
                    child: Text(
                      'BACK',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Opacity(
                    opacity: 0,
                    child: TextButton(
                      onPressed: null,
                      child: Text('SKIP'),
                    ),
                  ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: TextButton(
                key: ValueKey(_currentPage),
                onPressed: () {
                  if (_currentPage < _slides.length - 1) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                    );
                  }
                },
                child: Text(
                  _currentPage == _slides.length - 1 ? 'NEXT' : 'NEXT',
                  style: TextStyle(
                    color: Color(0xFF2BACE2),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}