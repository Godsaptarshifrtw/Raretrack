import 'package:flutter/material.dart';
import 'package:rare_disease_app/firebase_options.dart';
import 'package:rare_disease_app/screens/home_screen.dart';
import 'package:rare_disease_app/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:rare_disease_app/screens/predict_output_screen.dart';
import 'package:rare_disease_app/screens/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RareTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  LoginScreen(),
      routes: {'/login': (context) => const LoginScreen(),
                '/predict': (context) => const PredictionOutputScreen(),
      }
    );
  }
}
//