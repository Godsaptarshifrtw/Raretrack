// lib/screens/profile_screen.dart
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _operationController = TextEditingController();
  final TextEditingController _diseaseController = TextEditingController();

  double? _bmi;

  void _calculateBMI() {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);
    if (height != null && weight != null && height > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
      });
    }
  }

  Widget _buildLabel(String label, {FontWeight fontWeight = FontWeight.normal}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0, bottom: 4),
      child: Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: fontWeight),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, Function(String)? onChanged}) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onChanged: onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Welcome, [User Name]!',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: AssetImage('assets/profile.jpg'),
                ),
              ),
              const SizedBox(height: 25),

              _buildLabel("Name:", fontWeight: FontWeight.bold),
              _buildLabel("[Name]"),
              _buildLabel("Email:", fontWeight: FontWeight.bold),
              _buildLabel("[Email]"),
              _buildLabel("Age:", fontWeight: FontWeight.bold),
              _buildLabel("[Age]"),
              _buildLabel("Gender:", fontWeight: FontWeight.bold),
              _buildLabel("[Gender]"),

              _buildLabel("Address"),
              _buildTextField("Enter your address", _addressController),

              _buildLabel("Height (cm)"),
              _buildTextField("e.g. 170", _heightController,
                  inputType: TextInputType.number, onChanged: (_) => _calculateBMI()),

              _buildLabel("Weight (kg)"),
              _buildTextField("e.g. 65", _weightController,
                  inputType: TextInputType.number, onChanged: (_) => _calculateBMI()),

              const SizedBox(height: 10),
              Text(
                _bmi == null ? "BMI: --" : "BMI: ${_bmi!.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),

              _buildLabel("Past Operations (if any)"),
              _buildTextField("Describe past operations", _operationController),

              _buildLabel("Past/Current Diseases (if any)"),
              _buildTextField("List diseases", _diseaseController),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
