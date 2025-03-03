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
// Widget build(BuildContext context) {
//   return Scaffold(
//     backgroundColor: hexColor('#F2F4F7'), // Ubah warna background Scaffold
//     body: _pages[_selectedIndex],
//     bottomNavigationBar: Container(
//       margin: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
//       height: 65,
//       decoration: BoxDecoration(
//         color: hexColor('#11B3CF'),
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black26,
//             blurRadius: 6,
//             spreadRadius: 1,
//             offset: Offset(0, 3),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: BottomAppBar(
//           color: Colors.transparent,
//           elevation: 0,
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 IconButton(
//                   iconSize: 30,
//                   padding: EdgeInsets.only(bottom: 10),
//                   icon: Icon(
//                     _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
//                     color: _selectedIndex == 0 ? hexColor('#FFFFFF') : hexColor('#FFFFFF'),
//                   ),
//                   onPressed: () => _onItemTapped(0),
//                 ),
//                 SizedBox(width: 20),
//                 IconButton(
//                   iconSize: 30,
//                   padding: EdgeInsets.only(bottom: 10),
//                   icon: Icon(
//                     _selectedIndex == 1 ? Icons.health_and_safety : Icons.health_and_safety_outlined,
//                     color: _selectedIndex == 1 ? hexColor('#FFFFFF') : hexColor('#FFFFFF'),
//                   ),
//                   onPressed: () => _onItemTapped(1),
//                 ),
//                 SizedBox(width: 20),
//                 IconButton(
//                   iconSize: 30,
//                   padding: EdgeInsets.only(bottom: 10),
//                   icon: Icon(
//                     _selectedIndex == 2 ? Icons.school : Icons.school_outlined,
//                     color: _selectedIndex == 2 ? hexColor('#FFFFFF') : hexColor('#FFFFFF'),
//                   ),
//                   onPressed: () => _onItemTapped(2),
//                 ),
//                 SizedBox(width: 20),
//                 IconButton(
//                   iconSize: 30,
//                   padding: EdgeInsets.only(bottom: 10),
//                   icon: Icon(
//                     _selectedIndex == 3 ? Icons.person : Icons.person_outline,
//                     color: _selectedIndex == 3 ? hexColor('#FFFFFF') : hexColor('#FFFFFF'),
//                   ),
//                   onPressed: () => _onItemTapped(3),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ),
//   );
// }
// }