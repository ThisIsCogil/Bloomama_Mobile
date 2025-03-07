// import 'package:flutter/material.dart';
// import 'screens/home_screen.dart';
// import 'screens/kesehatan_screen.dart';
// import 'screens/mentor_screen.dart';
// import 'screens/profile_screen.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: MainScreen(),
//     );
//   }
// }

// class MainScreen extends StatefulWidget {
//   @override
//   _MainScreenState createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _pages = [
//     HomeScreen(),
//     KesehatanScreen(),
//     MentorScreen(),
//     ProfileScreen(),
//   ];

//   Color hexColor(String hex) {
//     return Color(int.parse(hex.replaceFirst('#', '0xFF')));
//   }

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: hexColor('#F2F4F7'),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Container(
//         margin: EdgeInsets.all(20),
//         decoration: BoxDecoration(
//           color: hexColor('#11B3CF'),
//           borderRadius: BorderRadius.circular(12),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black26,
//               blurRadius: 6,
//               spreadRadius: 1,
//               offset: Offset(0, 3),
//             ),
//           ],
//         ),
//         child: ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: BottomNavigationBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             type: BottomNavigationBarType.fixed,
//             selectedItemColor: Colors.white,
//             unselectedItemColor: Colors.white60,
//             currentIndex: _selectedIndex,
//             onTap: _onItemTapped,
//             items: [
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.home_outlined),
//                 activeIcon: Icon(Icons.home),
//                 label: "Home",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.health_and_safety_outlined),
//                 activeIcon: Icon(Icons.health_and_safety),
//                 label: "Kesehatan",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.school_outlined),
//                 activeIcon: Icon(Icons.school),
//                 label: "Mentor",
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(Icons.person_outline),
//                 activeIcon: Icon(Icons.person),
//                 label: "Profile",
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }