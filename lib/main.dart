import 'package:flutter/material.dart';
import 'package:rare_disease_app/screens/home_screen.dart';
import 'package:rare_disease_app/screens/login_screen.dart';
import 'package:rare_disease_app/screens/signup_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Violet Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  HomeScreen(), // ✅ Use your external login screen here
    );
  }
}
