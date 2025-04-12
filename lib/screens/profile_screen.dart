import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  List<TextEditingController> _operationControllers = [TextEditingController()];
  List<TextEditingController> _diseaseControllers = [TextEditingController()];

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

  Widget _buildHeadingField({
    required String heading,
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
    Function(String)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicFields({
    required String heading,
    required String hint,
    required List<TextEditingController> controllers,
    required VoidCallback onAdd,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                heading,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 10),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...controllers.map(
                (controller) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleField(
      String heading,
      String hint,
      TextEditingController controller, {
        TextInputType inputType = TextInputType.text,
        Function(String)? onChanged,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 200,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 80,
                    backgroundImage: AssetImage('assets/pp.webp'),
                    backgroundColor: Colors.white,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _nameController.text.isEmpty
                        ? 'Your Name'
                        : _nameController.text,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      _buildHeadingField(
                        heading: "Email",
                        hint: "Enter your email",
                        controller: _emailController,
                      ),
                      _buildHeadingField(
                        heading: "Age",
                        hint: "Enter your age",
                        controller: _ageController,
                        inputType: TextInputType.number,
                      ),
                      _buildHeadingField(
                        heading: "Gender",
                        hint: "Enter your gender",
                        controller: _genderController,
                      ),
                      _buildHeadingField(
                        heading: "Address",
                        hint: "Enter your address",
                        controller: _addressController,
                      ),
                      _buildSimpleField("Height (cm)", "Enter your height", _heightController,
                          inputType: TextInputType.number,
                          onChanged: (_) => _calculateBMI()),
                      _buildSimpleField("Weight (kg)", "Enter your weight", _weightController,
                          inputType: TextInputType.number,
                          onChanged: (_) => _calculateBMI()),
                      const SizedBox(height: 10),
                      Text(
                        _bmi == null
                            ? "BMI: --"
                            : "BMI: ${_bmi!.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildDynamicFields(
                        heading: "Past Operations (if any)",
                        hint: "Enter an operation",
                        controllers: _operationControllers,
                        onAdd: () {
                          setState(() {
                            _operationControllers.add(TextEditingController());
                          });
                        },
                      ),
                      _buildDynamicFields(
                        heading: "Past/Current Diseases (if any)",
                        hint: "Enter a disease",
                        controllers: _diseaseControllers,
                        onAdd: () {
                          setState(() {
                            _diseaseControllers.add(TextEditingController());
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
