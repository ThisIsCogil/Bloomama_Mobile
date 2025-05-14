// import 'package:flutter/material.dart';
// import '../controllers/login_controller.dart';
// import '../widgets/password_text_field.dart';
// import 'package:lottie/lottie.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen>
//     with SingleTickerProviderStateMixin {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   late LoginController _loginController;
//   late AnimationController _animationController;
//   late Animation<Offset> _slideAnimation;
//   bool _isLoginFormVisible = false;
//   bool _isRegisterFormVisible = false;

//   // Register form controllers
//   final TextEditingController _registerNameController = TextEditingController();
//   final TextEditingController _registerEmailController =
//       TextEditingController();
//   final TextEditingController _registerPasswordController =
//       TextEditingController();
//   final TextEditingController _registerConfirmPasswordController =
//       TextEditingController();

//   final Color primaryColor = const Color(0xFF11B3CF);

//   @override
//   void initState() {
//     super.initState();
//     _loginController = LoginController(
//       usernameController: _emailController,
//       passwordController: _passwordController,
//     );

//     _animationController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, 1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOut,
//     ));
//   }

//   void _showLoginForm() {
//     setState(() {
//       _isLoginFormVisible = true;
//       _isRegisterFormVisible = false;
//     });
//     _animationController.forward();
//   }

//   void _showRegisterForm() {
//     setState(() {
//       _isLoginFormVisible = false;
//       _isRegisterFormVisible = true;
//     });
//     _animationController.forward();
//   }

//   void _hideBottomForms() {
//     _animationController.reverse().then((_) {
//       setState(() {
//         _isLoginFormVisible = false;
//         _isRegisterFormVisible = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     return Scaffold(
//       body: Stack(
//         children: [
//           // Gradient background
//           Container(
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 colors: [
//                   primaryColor,
//                   primaryColor.withOpacity(0.8),
//                 ],
//               ),
//             ),
//           ),

//           // Wave painter
//           Positioned(
//             top: 0,
//             left: 0,
//             right: 0,
//             height: size.height * 0.3,
//             child: CustomPaint(
//               painter: TopWavePainter(),
//             ),
//           ),
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             height: size.height * 0.6,
//             child: CustomPaint(
//               painter: BottomShapePainter(),
//             ),
//           ),

//           // Circle decorations
//           Positioned(
//             top: -120,
//             right: -100,
//             child: _circleDecoration(250, Colors.white.withOpacity(0.1)),
//           ),
//           Positioned(
//             bottom: -80,
//             left: -100,
//             child: _circleDecoration(200, Colors.white.withOpacity(0.1)),
//           ),
//           Positioned(
//             top: size.height * 0.6,
//             right: -40,
//             child: _circleDecoration(120, Colors.white.withOpacity(0.05)),
//           ),

//           SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 30.0),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 40),
//                   const Text(
//                     'Welcome To,',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const Text(
//                     'Bloomama',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   const Text(
//                     'Start Your Pregnancy Journey From Now!',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                     ),
//                   ),
//                   const Spacer(flex: 1),
//                   SizedBox(
//                     width: 340,
//                     height: 340,
//                     child: Lottie.asset('assets/lottie/login.json',
//                         fit: BoxFit.contain),
//                   ),
//                   const Spacer(flex: 1),
//                   ElevatedButton(
//                     onPressed: _showLoginForm,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       foregroundColor: primaryColor,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 40, vertical: 15),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30),
//                         side: BorderSide.none, // Tidak ada border
//                       ),
//                       elevation: 0, // Jika tidak ingin ada bayangan
//                     ),
//                     child: Row(
//                       mainAxisSize:
//                           MainAxisSize.min, // Sesuaikan ukuran dengan konten
//                       children: [
//                         const Text(
//                           'Let\'s Start',
//                           style: TextStyle(
//                               fontSize: 16, fontWeight: FontWeight.w600),
//                         ),
//                         const SizedBox(width: 8), // Jarak antara teks dan ikon
//                         Icon(Icons.arrow_forward, color: primaryColor),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                 ],
//               ),
//             ),
//           ),

//           if (_isLoginFormVisible || _isRegisterFormVisible)
//             Positioned(
//               bottom: 0,
//               left: 0,
//               right: 0,
//               child: SlideTransition(
//                 position: _slideAnimation,
//                 child: _isLoginFormVisible
//                     ? _buildLoginForm()
//                     : _buildRegisterForm(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _circleDecoration(double size, Color color) {
//     return Container(
//       width: size,
//       height: size,
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         color: color,
//       ),
//     );
//   }

//   Widget _buildLoginForm() {
//     return _buildBottomSheet(
//       title: "Login",
//       fields: [
//         _textField(
//             controller: _emailController,
//             label: "Email",
//             hint: "you@example.com"),
//         const SizedBox(height: 12),
//         PasswordTextField(
//             controller: _passwordController, primaryColor: primaryColor),
//       ],
//       buttonText: "Login",
//       onSubmit: () => _loginController.handleLogin(context),
//       switchText: "Create a new account",
//       onSwitch: () {
//         _hideBottomForms();
//         Future.delayed(const Duration(milliseconds: 300), _showRegisterForm);
//       },
//     );
//   }

//   Widget _buildRegisterForm() {
//     return _buildBottomSheet(
//       title: "Register",
//       fields: [
//         _textField(
//             controller: _registerNameController,
//             label: "Full Name",
//             hint: "John Doe"),
//         const SizedBox(height: 12),
//         _textField(
//             controller: _registerEmailController,
//             label: "Email",
//             hint: "you@example.com"),
//         const SizedBox(height: 12),
//         PasswordTextField(
//             controller: _registerPasswordController,
//             primaryColor: primaryColor),
//         const SizedBox(height: 12),
//         PasswordTextField(
//             controller: _registerConfirmPasswordController,
//             primaryColor: primaryColor,
//             labelText: "Confirm Password"),
//       ],
//       buttonText: "Register",
//       onSubmit: () => print("Handle register here"),
//       switchText: "Already have an account?",
//       onSwitch: () {
//         _hideBottomForms();
//         Future.delayed(const Duration(milliseconds: 300), _showLoginForm);
//       },
//     );
//   }

//   Widget _buildBottomSheet({
//     required String title,
//     required List<Widget> fields,
//     required String buttonText,
//     required VoidCallback onSubmit,
//     required String switchText,
//     required VoidCallback onSwitch,
//   }) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(30),
//           topRight: Radius.circular(30),
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black12,
//             blurRadius: 10,
//             offset: Offset(0, -5),
//           ),
//         ],
//       ),
//       padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back_ios),
//                   onPressed: _hideBottomForms,
//                   iconSize: 18,
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                       fontSize: 22, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             ...fields,
//             const SizedBox(height: 16),
//             SizedBox(
//               width: double.infinity,
//               height: 48,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: primaryColor,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(25)),
//                 ),
//                 onPressed: onSubmit,
//                 child: Text(buttonText,
//                     style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold)),
//               ),
//             ),
//             const SizedBox(height: 20),
//             Center(
//               child: GestureDetector(
//                 onTap: onSwitch,
//                 child: Text(
//                   switchText,
//                   style: TextStyle(
//                     color: primaryColor,
//                     fontWeight: FontWeight.w500,
//                     decoration: TextDecoration.underline,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _textField(
//       {required TextEditingController controller,
//       required String label,
//       required String hint}) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hint,
//         labelText: label,
//         labelStyle: TextStyle(color: Colors.grey.shade600),
//         floatingLabelStyle: TextStyle(color: primaryColor),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: primaryColor, width: 2),
//         ),
//         fillColor: Colors.grey.shade100,
//         filled: true,
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       ),
//       keyboardType: TextInputType.emailAddress,
//     );
//   }
// }

// // Custom painter for top wave pattern
// class TopWavePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.white.withOpacity(0.15)
//       ..style = PaintingStyle.fill;
//     final Path path = Path();

//     path.moveTo(0, size.height);
//     path.quadraticBezierTo(
//         size.width * 0.5, size.height * 0.4, size.width, size.height);
//     path.lineTo(size.width, 0);
//     path.lineTo(0, 0);

//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // Second wave with a different style
// class SecondWavePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.white.withOpacity(0.1)
//       ..style = PaintingStyle.fill;
//     final Path path = Path();

//     path.moveTo(0, size.height);
//     path.cubicTo(size.width * 0.25, size.height * 0.6, size.width * 0.75,
//         size.height * 0.1, size.width, size.height);
//     path.lineTo(size.width, 0);
//     path.lineTo(0, 0);

//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

// // Custom painter for bottom shape
// class BottomShapePainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.white
//       ..style = PaintingStyle.fill;

//     final Path path = Path();

//     path.moveTo(0, size.height);
//     path.lineTo(size.width, size.height);
//     path.lineTo(size.width, size.height * 0.2);
//     path.quadraticBezierTo(size.width / 2, 0, 0, size.height * 0.2);

//     path.close();
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
