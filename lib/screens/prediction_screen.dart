import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _symptomNameController = TextEditingController();
  final TextEditingController _symptomOnsetDateController = TextEditingController();
  final TextEditingController _outcomeController = TextEditingController();

  final List<String> allSymptoms = [
    "swelling in legs","indigestion", "swelling","speech difficulties",
    "runny nose","loss of interest","itchy eyes","weight loss","sneezing",
    "rapid heartbeat","numbness","fever","whiteheads","skin irritation",
    "itchy skin","fatigue","sensitivity to light and sound","fade","muscle tension",
    "diarrhea","dry patches","tremors","bradykinesia","headaches","abdominal pain",
    "weakness","vision problems","excessive thirst","chest pain","blackheads",
    "chest tightness","blood in sputum","blurred vision","cloudy urine",
    "nasal congestion","shortness of breath","pale skin","coughing","loss of appetite",
    "sleep disturbances","night sweats","difficulty walking","thoughts of death",
    "joint pain","stomach pain","bloody stools","severe headache","reduced range of motion",
    "weight gain/loss","loss of taste and smell","vomiting","wheezing","persistent sadness",
    "hair thinning","dizziness","painful urination","jaundice","persistent cough",
    "rigidity","inflammation","pimples","swollen lymph nodes","postural instability",
    "restlessness","muscle spasms","slow healing wounds","frequent urination","sore throat",
    "redness","difficulty concentrating","visual disturbances","cold hands and feet",
    "stiffness","lower abdominal pain","cough","dry skin","sensitivity to cold/heat",
    "nausea",
  ];
  List<String> selectedSymptoms = [];

  String? _selectedGender;
  String? _diseaseName;

  @override
  void initState() {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('User UID: $uid');
    _loadUserData();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    const violet = Colors.deepPurple;

    return Scaffold(
      backgroundColor: violet,
      body: SafeArea(
        child: Column(
          children: [
            // 🔝 Top Sheet/Header
            Container(
              height: 80,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: violet,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
            ),
            // 📄 Form Section
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
                      children: [
                        _buildHeadingField(
                          heading: "Gender",
                          hint: "Enter your gender",
                          controller: _genderController,
                        ),
                        _buildHeadingField(
                          heading: "Age",
                          hint: "Enter your Age",
                          controller: _ageController,
                        ),
                        SizedBox(height: 16),
                        _buildSymptomSearchDropdown(),
                        SizedBox(height: 16),
                        _buildHeadingField(
                          heading: "Symptom Persisting for(Days)",
                          controller: _symptomOnsetDateController,
                          hint: "20(days)",
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Predicting...")),
                              );

                              final uid = FirebaseAuth.instance.currentUser?.uid;
                              if (uid == null) return;

                              // Prepare the updated data
                              Map<String, dynamic> updatedData = {
                                'age': _ageController.text.trim(),
                                'gender': _genderController.text.trim(),
                                'Symptoms': selectedSymptoms.map((c) => c.trim()).toList(),
                                'Days': _symptomOnsetDateController.text.trim(),
                              };

                              try {
                                await FirebaseFirestore.instance
                                    .collection('Users') // Use your actual collection name
                                    .doc(uid)
                                    .update(updatedData);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Profile updated successfully!")),
                                );

                                // Prepare the prediction model for the next screen (mocking it here)
                                PredictionModel prediction = PredictionModel(
                                  predictedDisease: "Disease XYZ",
                                  probability: 0.85,
                                  topPredictions: [
                                    TopPrediction(disease: "Disease ABC", probability: 0.9),
                                    TopPrediction(disease: "Disease DEF", probability: 0.75),
                                  ],
                                  medications: ["Med 1", "Med 2"],
                                  consultDoctor: "Yes, see a doctor.",
                                );

                                // Navigate to PredictionOutputScreen and pass the prediction data
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PredictionOutputScreen(prediction: prediction),
                                  ),
                                );
                              } catch (e) {
                                print("Error updating profile: $e");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Failed to update profile.")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: violet,
                            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Predict",
                            style: TextStyle(color: Colors.white, fontSize: 16),
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

  Widget _buildSymptomSearchDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select Symptoms",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
                  ? const Text(
                "No symptoms selected",
                style: TextStyle(color: Colors.grey),
              )
                  : Wrap(
                spacing: 8,
                runSpacing: 6,
                children: selectedItems.map((e) {
                  return Chip(
                    label: Text(
                      e,
                      style: const TextStyle(fontSize: 14),
                    ),
                    backgroundColor: Colors.deepPurple.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
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

  void _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      DocumentSnapshot user;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

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
}

class PredictionModel {
  final String predictedDisease;
  final double probability;
  final List<TopPrediction> topPredictions;
  final List<String> medications;
  final String consultDoctor;

  PredictionModel({
    required this.predictedDisease,
    required this.probability,
    required this.topPredictions,
    required this.medications,
    required this.consultDoctor,
  });
}

class TopPrediction {
  final String disease;
  final double probability;

  TopPrediction({required this.disease, required this.probability});
}

class PredictionOutputScreen extends StatelessWidget {
  final PredictionModel prediction;

  const PredictionOutputScreen({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prediction Results"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Predicted Disease: ${prediction.predictedDisease}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Probability: ${(prediction.probability * 100).toStringAsFixed(2)}%",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Top Predictions:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...prediction.topPredictions.map((topPrediction) {
              return Text(
                "${topPrediction.disease}: ${(topPrediction.probability * 100).toStringAsFixed(2)}%",
                style: const TextStyle(fontSize: 14),
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              "Suggested Medications:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...prediction.medications.map((medication) {
              return Text(
                medication,
                style: const TextStyle(fontSize: 14),
              );
            }).toList(),
            const SizedBox(height: 20),
            Text(
              "Consult a doctor: ${prediction.consultDoctor}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
