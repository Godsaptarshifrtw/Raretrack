import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rare_disease_app/screens/predict_output_screen.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _symptomOnsetDateController = TextEditingController();

  final List<String> allSymptoms = [
    "swelling in legs", "indigestion", "swelling", "speech difficulties", "runny nose", "loss of interest",
    "itchy eyes", "weight loss", "sneezing", "rapid heartbeat", "numbness", "fever", "whiteheads", "skin irritation",
    "itchy skin", "fatigue", "sensitivity to light and sound", "fade", "muscle tension", "diarrhea", "dry patches",
    "tremors", "bradykinesia", "headaches", "abdominal pain", "weakness", "vision problems", "excessive thirst",
    "chest pain", "blackheads", "chest tightness", "blood in sputum", "blurred vision", "cloudy urine",
    "nasal congestion", "shortness of breath", "pale skin", "coughing", "loss of appetite", "sleep disturbances",
    "night sweats", "difficulty walking", "thoughts of death", "joint pain", "stomach pain", "bloody stools",
    "severe headache", "reduced range of motion", "weight gain/loss", "loss of taste and smell", "vomiting",
    "wheezing", "persistent sadness", "hair thinning", "dizziness", "painful urination", "jaundice", "persistent cough",
    "rigidity", "inflammation", "pimples", "swollen lymph nodes", "postural instability", "restlessness",
    "muscle spasms", "slow healing wounds", "frequent urination", "sore throat", "redness", "difficulty concentrating",
    "visual disturbances", "cold hands and feet", "stiffness", "lower abdominal pain", "cough", "dry skin",
    "sensitivity to cold/heat", "nausea",
  ];

  List<String> selectedSymptoms = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();

      if (userDoc.exists) {
        setState(() {
          _ageController.text = userDoc['age'] ?? '';
          _genderController.text = userDoc['gender'] ?? '';
          selectedSymptoms = List<String>.from(userDoc['Symptoms'] ?? []);
          _symptomOnsetDateController.text = userDoc['Days'] ?? '';
        });
      }
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Widget _buildHeadingField({
    required String heading,
    required String hint,
    required TextEditingController controller,
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(heading, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: inputType,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSymptomSearchDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Symptoms", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        DropdownSearch<String>.multiSelection(
          items: (String? filter, _) async {
            final lowercaseFilter = filter?.toLowerCase() ?? '';
            return allSymptoms
                .where((symptom) => symptom.toLowerCase().contains(lowercaseFilter))
                .toList();
          },
          selectedItems: selectedSymptoms,
          onChanged: (List<String> selectedList) {
            setState(() {
              selectedSymptoms = selectedList;
            });
          },
          popupProps: PopupPropsMultiSelection.menu(
            showSearchBox: true,
            showSelectedItems: true,
            menuProps: MenuProps(
              backgroundColor: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            searchFieldProps: TextFieldProps(
              decoration: InputDecoration(
                hintText: "Search symptoms...",
                prefixIcon: const Icon(Icons.search, color: Colors.deepPurple),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurple),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.deepPurple, width: 1.5),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              ),
            ),
          ),
          dropdownBuilder: (context, selectedItems) {
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple, width: 1),
              ),
              child: selectedItems.isEmpty
                  ? const Text("No symptoms selected", style: TextStyle(color: Colors.grey))
                  : Wrap(
                spacing: 8,
                runSpacing: 6,
                children: selectedItems.map((e) {
                  return Chip(
                    label: Text(e, style: const TextStyle(fontSize: 14)),
                    backgroundColor: Colors.deepPurple.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    deleteIcon: const Icon(Icons.close, size: 18, color: Colors.deepPurple),
                    onDeleted: () {
                      setState(() {
                        selectedSymptoms = List.from(selectedSymptoms)..remove(e);
                      });
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }

  void _handlePrediction() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Predicting...")));

      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) return;

      Map<String, dynamic> updatedData = {
        'age': _ageController.text.trim(),
        'gender': _genderController.text.trim(),
        'Symptoms': selectedSymptoms.map((c) => c.trim()).toList(),
        'Days': _symptomOnsetDateController.text.trim(),
      };

      try {
        await FirebaseFirestore.instance.collection('Users').doc(uid).update(updatedData);



        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PredictionOutputScreen()),
        );
      } catch (e) {
        print("Error updating profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update profile.")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const violet = Colors.deepPurple;

    return Scaffold(
      backgroundColor: violet,
      appBar: AppBar(
        backgroundColor: violet,
        elevation: 0,
        title: const Text("Disease Predictor", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white70)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Fill in your information and symptoms to predict your condition.",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        _buildHeadingField(
                          heading: "Gender",
                          hint: "Enter your gender",
                          controller: _genderController,
                        ),
                        _buildHeadingField(
                          heading: "Age",
                          hint: "Enter your age",
                          controller: _ageController,
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 12),
                        _buildSymptomSearchDropdown(),
                        const SizedBox(height: 16),
                        _buildHeadingField(
                          heading: "Symptom Persisting for (Days)",
                          controller: _symptomOnsetDateController,
                          hint: "e.g., 20",
                          inputType: TextInputType.number,
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: ElevatedButton(
                            onPressed: _handlePrediction,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: violet,
                              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 4,
                            ),
                            child: const Text(
                              "Predict",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
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
