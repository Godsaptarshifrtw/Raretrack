import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({
    super.key,
  });

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
  final TextEditingController _bmiController = TextEditingController();

  @override
  void initState() {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('User UID: $uid');
    _loadUserData();
  }

  List<TextEditingController> _operationControllers = [TextEditingController()];
  List<TextEditingController> _diseaseControllers = [TextEditingController()];

  double? _bmi;

  void _calculateBMI({bool force = false}) {
    final double? height = double.tryParse(_heightController.text);
    final double? weight = double.tryParse(_weightController.text);
    if (height != null && weight != null && height > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
        _bmiController.text = _bmi!.toStringAsFixed(2);
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


  Widget _buildAddressField({
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
            maxLines: 5,
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
    required void Function(int) onRemove, // new parameter
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
              const SizedBox(width: 7),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle, color: Colors.deepPurple),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ...List.generate(controllers.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controllers[index],
                      decoration: InputDecoration(
                        hintText: hint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                    onPressed: () => onRemove(index),
                  ),
                ],
              ),
            );
          }),
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
                        : "Welcome ${_nameController.text}",
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
                      _buildAddressField(

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
                      if (_bmiController.text.isNotEmpty)
                        Text(
                          "BMI: ${_bmiController.text}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        )
                      else
                        const Text(
                          "BMI: --",
                          style: TextStyle(
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
                        onRemove: (index) {
                          setState(() {
                            if (_operationControllers.length > 1) {
                              _operationControllers.removeAt(index);
                            }
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
                        onRemove: (index) {
                          setState(() {
                            if (_diseaseControllers.length > 1) {
                              _diseaseControllers.removeAt(index);
                            }
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            final uid = FirebaseAuth.instance.currentUser?.uid;
                            if (uid == null) return;

                            // Prepare the updated data
                            Map<String, dynamic> updatedData = {
                              'name': _nameController.text.trim(),
                              'email': _emailController.text.trim(),
                              'age': _ageController.text.trim(),
                              'gender': _genderController.text.trim(),
                              'bmi': _bmiController.text.trim(),
                              'address': _addressController.text.trim(),
                              'height': _heightController.text.trim(),
                              'weight': _weightController.text.trim(),
                              'pastOperations': _operationControllers.map((c) => c.text.trim()).toList(),
                              'diseases': _diseaseControllers.map((c) => c.text.trim()).toList(),
                            };

                            try {
                              await FirebaseFirestore.instance
                                  .collection('Users') // use your actual collection name
                                  .doc(uid)
                                  .update(updatedData);

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Profile updated successfully!")),
                              );
                            } catch (e) {
                              print("Error updating profile: $e");
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Failed to update profile.")),
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Save",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
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
  void _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _ageController.text = data['age'] ?? '';
          _genderController.text = data['gender'] ?? '';
          _addressController.text = data['address'] ?? '';
          _heightController.text = data['height'] ?? '';
          _weightController.text = data['weight'] ?? '';
          _bmiController.text = data['bmi'] ?? '';

          // BMI is calculated if not fetched from server
          _calculateBMI(force: true);

          _operationControllers = (data['pastOperations'] as List<dynamic>? ?? [])
              .map((e) => TextEditingController(text: e.toString()))
              .toList();

          if (_operationControllers.isEmpty) {
            _operationControllers.add(TextEditingController());
          }

          _diseaseControllers = (data['diseases'] as List<dynamic>? ?? [])
              .map((e) => TextEditingController(text: e.toString()))
              .toList();

          if (_diseaseControllers.isEmpty) {
            _diseaseControllers.add(TextEditingController());
          }
        });

        print("User data loaded");
      } else {
        print("User document not found");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }
}
