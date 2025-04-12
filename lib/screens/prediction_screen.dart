import 'package:flutter/material.dart';

class PredictionScreen extends StatelessWidget {
  const PredictionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Make your prediction here!',
        style: TextStyle(fontSize: 18),
      ),
    );
  }
}
