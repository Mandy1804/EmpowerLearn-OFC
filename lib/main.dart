import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const EmpowerLearnApp());
}

class EmpowerLearnApp extends StatelessWidget {
  const EmpowerLearnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EmpowerLearn',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF020817),
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginPage(),
    );
  }
}