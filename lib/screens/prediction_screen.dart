import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _symptomNameController = TextEditingController();
  final TextEditingController _symptomSeverityController = TextEditingController();
  final TextEditingController _symptomOnsetDateController = TextEditingController();
  final TextEditingController _logDateController = TextEditingController();
  final TextEditingController _medicationNameController = TextEditingController();
  final TextEditingController _medicationDoseController = TextEditingController();
  final TextEditingController _outcomeController = TextEditingController();
  final TextEditingController _moodScoreController = TextEditingController();
  final TextEditingController _painScoreController = TextEditingController();
  final TextEditingController _doctorVisitDateController = TextEditingController();
  final TextEditingController _diagnosticsController = TextEditingController();

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
                        _buildField("Age", _ageController, inputType: TextInputType.number),
                        _buildDropdown("Gender", ["Male", "Female", "Other"], (value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        }, _selectedGender),
                        _buildDropdown("Disease Name", ["Diabetes", "Hypertension", "COVID-19", "Asthma"], (value) {
                          setState(() {
                            _diseaseName = value;
                          });
                        }, _diseaseName),
                        _buildField("Symptom Name", _symptomNameController),
                        _buildField("Symptom Severity", _symptomSeverityController),
                        _buildField("Symptom Onset Date", _symptomOnsetDateController, hint: "yyyy-mm-dd"),
                        _buildField("Log Date", _logDateController, hint: "yyyy-mm-dd"),
                        _buildField("Medication Name", _medicationNameController),
                        _buildField("Medication Dose", _medicationDoseController),
                        _buildField("Outcome", _outcomeController),
                        _buildField("Mood Score", _moodScoreController, inputType: TextInputType.number),
                        _buildField("Pain Score", _painScoreController, inputType: TextInputType.number),
                        _buildField("Doctor Visit Date", _doctorVisitDateController, hint: "yyyy-mm-dd"),
                        _buildField("Diagnostics/Tests", _diagnosticsController),

                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Predicting...")),
                              );
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

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? "Select $label" : null,
      ),
    );
  }
}