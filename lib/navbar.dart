import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'screens/home_screen.dart';
import 'screens/kesehatan_screen.dart';
import 'screens/mentor_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool _isNavbarVisible = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final direction = _scrollController.position.userScrollDirection;
      if (direction == ScrollDirection.reverse) {
        if (_isNavbarVisible) {
          setState(() {
            _isNavbarVisible = false;
          });
        }
      } else if (direction == ScrollDirection.forward) {
        if (!_isNavbarVisible) {
          setState(() {
            _isNavbarVisible = true;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      HomeScreen(scrollController: _scrollController),
      KesehatanScreen(scrollController: _scrollController),
      MentorScreen(scrollController: _scrollController),
      ProfileScreen(scrollController: _scrollController),
    ];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: AnimatedOpacity(
          opacity: _isNavbarVisible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 300),
          child: Visibility(
            visible: _isNavbarVisible,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Color(0xFF11B3CF),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BottomNavigationBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  type: BottomNavigationBarType.fixed,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.white60,
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.health_and_safety_outlined),
                      activeIcon: Icon(Icons.health_and_safety),
                      label: "Kesehatan",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.school_outlined),
                      activeIcon: Icon(Icons.school),
                      label: "Mentor",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline),
                      activeIcon: Icon(Icons.person),
                      label: "Profile",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
