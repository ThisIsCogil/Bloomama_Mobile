// import 'package:flutter/material.dart';
// import 'screens/home_screen.dart';
// import 'screens/kesehatan_screen.dart';
// import 'screens/mentor_screen.dart';
// import 'screens/profile_screen.dart';


// class AnimatedNavBar extends StatefulWidget {
//   final int selectedIndex;
//   final Function(int) onItemSelected;

//   AnimatedNavBar({
//     required this.selectedIndex,
//     required this.onItemSelected,
//   });

//   @override
//   _AnimatedNavBarState createState() => _AnimatedNavBarState();
// }

// class _AnimatedNavBarState extends State<AnimatedNavBar> {
//   int? hoveredIndex;

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final itemWidth = constraints.maxWidth / 4;
        
//         return Stack(
//           children: [
//             AnimatedPositioned(
//               duration: Duration(milliseconds: 250),
//               curve: Curves.easeOutCubic,
//               left: widget.selectedIndex * itemWidth,
//               top: 5,
//               bottom: 5,
//               width: itemWidth,
//               child: Container(
//                 margin: EdgeInsets.symmetric(horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   borderRadius: BorderRadius.circular(15),
//                 ),
//               ),
//             ),
            
           
//             Row(
//               children: [
//                 Expanded(child: _buildNavItem(context, 0, Icons.home_outlined, 'Home')),
//                 Expanded(child: _buildNavItem(context, 1, Icons.calendar_today_outlined, 'Healthy')),
//                 Expanded(child: _buildNavItem(context, 2, Icons.people_outline,'Community')),
//                 Expanded(child: _buildNavItem(context, 3, Icons.person_outline, 'Profile')),
//               ],
//             ),
//           ],
//         );
//       }
//     );
//   }

//   Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
//     final bool isSelected = widget.selectedIndex == index;
//     final bool isHovered = hoveredIndex == index;
    
//     return MouseRegion(
//       onEnter: (_) => setState(() => hoveredIndex = index),
//       onExit: (_) => setState(() => hoveredIndex = null),
//       child: GestureDetector(
//         onTap: () => widget.onItemSelected(index),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AnimatedContainer(
//               duration: Duration(milliseconds: 200),
//               padding: EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: isHovered && !isSelected ? Colors.white.withOpacity(0.1) : Colors.transparent,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(
//                 icon,
//                 color: Colors.white,
//                 size: 24,
//               ),
//             ),
//             if (isSelected)
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 6),
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 12,
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: hexColor('#F2F4F7'),
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: Padding(
//         padding: EdgeInsets.only(bottom: 20),
//         child: Container(
//           margin: EdgeInsets.symmetric(horizontal: 20),
//           height: 70,
//           decoration: BoxDecoration(
//             color: hexColor('#16B5C5'),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 8,
//                 spreadRadius: 1,
//                 offset: Offset(0, 4),
//               ),
//             ],
//           ),
//           child: AnimatedNavBar(
//             selectedIndex: _selectedIndex,
//             onItemSelected: (index) {
//               setState(() {
//                 _selectedIndex = index;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }