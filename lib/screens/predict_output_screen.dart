import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disease Predictor',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomeScreen({super.key});

  void _handleSearch(BuildContext context) async {
    final symptoms = _controller.text.trim();
    if (symptoms.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter symptoms")),
      );
      return;
    }

    try {
      // Predict disease category from symptoms (this could be replaced with an actual prediction logic)
      final predictedDisease = "Flu";
      final probability = 0.85;

      // Example top predictions (this can be expanded based on the actual logic)
      final topPredictions = [
        TopPrediction(disease: "Cold", probability: 0.80),
        TopPrediction(disease: "Cough", probability: 0.75),
      ];

      // Example medications
      final medications = [
        "Paracetamol",
        "Vitamin C",
      ];

      // Simulate doctor consultation suggestion
      final consultDoctor = "Consult a doctor if symptoms persist.";

      // Create prediction model
      final prediction = PredictionModel(
        predictedDisease: predictedDisease,
        probability: probability,
        topPredictions: topPredictions,
        medications: medications,
        consultDoctor: consultDoctor,
      );

      // Navigate to PredictionOutputScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PredictionOutputScreen(prediction: prediction),
        ),
      );
    } catch (e) {
      // Show error dialog
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Disease Predictor")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: "Enter Symptoms",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.local_hospital),
              label: const Text("Predict & Find Doctors"),
              onPressed: () => _handleSearch(context),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PredictionOutputScreen extends StatelessWidget {
  final PredictionModel prediction;

  const PredictionOutputScreen({Key? key, required this.prediction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Prediction Output"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildPredictionCard(),
            const SizedBox(height: 20),
            _buildTopPredictions(),
            const SizedBox(height: 20),
            _buildMedications(),
            const SizedBox(height: 20),
            _buildConsultDoctor(),
            const SizedBox(height: 20),
            _buildAdditionalInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Predicted Disease: ${prediction.predictedDisease ?? "N/A"}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Probability: ${(prediction.probability != null) ? (prediction.probability! * 100).toStringAsFixed(2) + "%" : "N/A"}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPredictions() {
    if (prediction.topPredictions.isEmpty) {
      return Container();
    }
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Top Predictions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (var topPrediction in prediction.topPredictions)
              ListTile(
                title: Text(topPrediction.disease ?? "N/A"),
                subtitle: Text("Probability: ${(topPrediction.probability != null) ? (topPrediction.probability! * 100).toStringAsFixed(2) + "%" : "N/A"}"),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedications() {
    if (prediction.medications.isEmpty) {
      return Container();
    }
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Suggested Medications",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (var medication in prediction.medications)
              Text(
                medication,
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultDoctor() {
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Consult Doctor: ${prediction.consultDoctor ?? "Not Available"}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Additional Information / Recommendations",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "• Please ensure proper follow-up care with your healthcare provider.",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "• Consider lifestyle changes, diet modifications, or other treatments as advised.",
              style: TextStyle(fontSize: 16),
            ),
            Text(
              "• Stay hydrated and monitor symptoms regularly.",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// PredictionModel class
class PredictionModel {
  PredictionModel({
    required this.predictedDisease,
    required this.probability,
    required this.topPredictions,
    required this.medications,
    required this.consultDoctor,
  });

  final String? predictedDisease;
  final double? probability;
  final List<TopPrediction> topPredictions;
  final List<String> medications;
  final String? consultDoctor;

  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      predictedDisease: json["predicted_disease"],
      probability: json["probability"],
      topPredictions: json["top_predictions"] == null
          ? []
          : List<TopPrediction>.from(
          json["top_predictions"]!.map((x) => TopPrediction.fromJson(x))),
      medications: json["medications"] == null
          ? []
          : List<String>.from(json["medications"]!.map((x) => x)),
      consultDoctor: json["consult_doctor"],
    );
  }
}

// TopPrediction class
class TopPrediction {
  TopPrediction({
    required this.disease,
    required this.probability,
  });

  final String? disease;
  final double? probability;

  factory TopPrediction.fromJson(Map<String, dynamic> json) {
    return TopPrediction(
      disease: json["disease"],
      probability: json["probability"],
    );
  }
}
