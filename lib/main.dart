import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:marketsapce_app/screens/login-screen.dart';
import 'package:marketsapce_app/screens/register-screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Market Space',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.karlaTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: RegisterScreen(),
    );
  }
}
