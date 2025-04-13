import 'package:flutter/material.dart';
import 'package:rare_disease_app/screens/login_screen.dart';
import 'package:rare_disease_app/screens/past%20prediction_screen.dart';
import 'package:rare_disease_app/screens/prediction_screen.dart';
import 'package:rare_disease_app/screens/profile_screen.dart';
import 'package:rare_disease_app/services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    ProfileScreen(),
    PredictionScreen(),
    PredictionHistoryScreen(),
  ];

  final List<String> _titles = [
    "Profile",
    "Disease Prediction",
    "Prediction History",
  ];
  FirebaseService _firebaseService = FirebaseService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple, // Set background color
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            _firebaseService.signOut();
            Navigator.popAndPushNamed(context, '/login');
          }, icon: Icon(Icons.logout))
        ],
        title: Text(_titles[_currentIndex]),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        color: Colors.white, // You can change this to transparent if widgets have their own background
        child: _screens[_currentIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Predict',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
