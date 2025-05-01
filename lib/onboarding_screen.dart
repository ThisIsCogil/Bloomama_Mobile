import 'package:flutter/material.dart';
import 'login.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  List<Map<String, dynamic>> _slides = [
    {
      'title': 'Education Resource',
      'image': 'assets/13.png',
      'description': 'The app will provide educational resources to help users learn about maternal health, including articles, videos, and podcasts'
    },
    {
      'title': 'Tracking Tools',
      'image': 'assets/16.png',
      'description': 'The app will provide tracking tools to help users monitor their pregnancy and postpartum progress, including weight tracking, contraction timing, and breastfeeding tracker.'
    },
    {
      'title': 'Lifesaving App',
      'image': 'assets/5.png',
      'description': 'A lifesaving mobile app that monitors pregnant womens health, provides emergency assistance, and connects users to medical help when complications arise'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    image: _slides[index]['image'],
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
    required String image,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          Text(
            title,
            style: GoogleFonts.nanumPenScript(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF4D8D),
            ),
          ),
          SizedBox(height: 40),
          Image.asset(
            image,
            height: 250,
          ),
          SizedBox(height: 40),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.mitr(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index) {
    return Container(
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
    return Padding(
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
          TextButton(
            onPressed: () {
              if (_currentPage < _slides.length - 1) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.ease,
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
            child: Text(
              'NEXT',
              style: TextStyle(
                color: Color(0xFF2BACE2),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}