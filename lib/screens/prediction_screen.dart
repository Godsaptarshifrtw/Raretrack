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
    "Abdominal pain", "Abnormal blood clotting", "Abnormal bleeding", "Agitation",
    "Anemia", "Anxiety", "Back pain", "Bleeding gums", "Blood in stool",
    "Blood in urine", "Blurred vision", "Bruising", "Chest pain", "Chills",
    "Cognitive impairment", "Confusion", "Cough", "Dark urine", "Dehydration",
    "Depression", "Diarrhea", "Dizziness", "Dry mouth", "Dysuria", "Fatigue",
    "Fever", "Hair loss", "Headache", "Hearing loss", "Heart palpitations",
    "High blood pressure", "Hot flashes", "Impaired wound healing",
    "Immunosuppression", "Increased appetite", "Indigestion", "Inflammation",
    "Insomnia", "Irregular heartbeat", "Itching", "Jaundice", "Joint pain",
    "Loss of appetite", "Low blood pressure", "Memory loss", "Muscle cramps",
    "Muscle pain", "Nausea", "Numbness", "Pale skin", "Palpitations", "Poor circulation",
    "Rash", "Seizures", "Shortness of breath", "Skin ulcers", "Sleep disturbances",
    "Sneezing", "Sore throat", "Stomach cramps", "Sweating", "Swelling",
    "Swollen lymph nodes", "Tingling sensation", "Tremors", "Vision changes",
    "Vomiting", "Weakness", "Weight gain", "Weight loss"
  ];
  List<String> selectedSymptoms = [];


  @override
  void initState() {
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
    print('User UID: $uid');
   _loadUserData();
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
  String? _selectedGender;
  String? _diseaseName;

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
                      _buildSymptomSearchDropdown(),
                        _buildField("Symptom Persisting for(Days)", _symptomOnsetDateController, hint: "20(days)"),



                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: ()  async {
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

  Widget _buildField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (value) => value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }
/*
          },*/
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
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      if (userDoc.exists) {
        final data = userDoc.data() as Map<String, dynamic>;

        setState(() {

          _ageController.text = data['age'] ?? '';
          _genderController.text = data['gender'] ?? '';


          // BMI is calculated if not fetched from server



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
