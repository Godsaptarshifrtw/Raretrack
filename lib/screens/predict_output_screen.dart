import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rare_disease_app/api/api_handler.dart';
import 'package:rare_disease_app/models/prediction_model.dart';
import 'package:rare_disease_app/services/location_service.dart' as LocationService;
import 'package:rare_disease_app/services/osm_service.dart';
import 'package:rare_disease_app/models/place_model.dart';
import 'package:rare_disease_app/screens/map_screen.dart';

class PredictionOutputScreen extends StatefulWidget {
  const PredictionOutputScreen({super.key});

  @override
  State<PredictionOutputScreen> createState() => _PredictionOutputScreenState();
}

class _PredictionOutputScreenState extends State<PredictionOutputScreen> {
  final TextEditingController _symptomSearchController = TextEditingController();

  List<String> _symptoms = [];
  String _days = '';
  String _age = '';
  String _gender = '';
  PredictionModel? _prediction;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserDataAndPredict();
  }

  Future<void> _loadUserDataAndPredict() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      print('No user is currently signed in.');
      setState(() => _isLoading = false);
      return;
    }

    try {
      final doc = await FirebaseFirestore.instance.collection('Users').doc(uid).get();
      final data = doc.data();
      if (data == null || !doc.exists) {
        setState(() => _isLoading = false);
        return;
      }

      _symptoms = List<String>.from(data['symptoms'] ?? []);
      _days = data['Days']?.toString() ?? '0';
      _age = data['age']?.toString() ?? '0';
      _gender = data['gender']?.toString() ?? 'Unknown';

      final apiHandler = ApiHandler();
      final prediction = await apiHandler.getPredictions(
        age: _age,
        gender: _gender,
        duration: _days,
        symptoms: _symptoms,
      );

      setState(() {
        _prediction = prediction;
        _isLoading = false;
      });
    } catch (e) {
      print('Error during prediction: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleNearbySearch(BuildContext context) async {


    try {
      final predictedCategory = "hospital"; // Placeholder
      final position = await LocationService.getCurrentLocation();
      final List<Place> places = await OSMService.getNearbyPlaces(
        position.latitude,
        position.longitude,
        predictedCategory,
      );

      if (places.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No nearby places found.")),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => MapScreen(
            lat: position.latitude,
            lng: position.longitude,
            places: places,
          ),
        ),
      );
    } catch (e) {
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
      appBar: AppBar(
        title: const Text("Prediction Result & Nearby Help"),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _prediction == null
          ? const Center(child: Text("Prediction data could not be loaded."))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildPredictionCard(),
            const SizedBox(height: 16),
            _buildTopPredictions(),
            const SizedBox(height: 16),
            _buildMedications(),
            const SizedBox(height: 16),
            _buildConsultDoctor(),
            const SizedBox(height: 16),
            _buildAdditionalInfo(),
            const Divider(height: 32),
            _buildNearbyHelpSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildPredictionCard() {
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Predicted Disease",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple.shade700)),
            const SizedBox(height: 8),
            Text(_prediction!.predictedDisease ?? "N/A",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              "Probability: ${_prediction!.probability != null ? (_prediction!.probability! * 100).toStringAsFixed(2) + "%" : "N/A"}",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopPredictions() {
    if (_prediction!.topPredictions.isEmpty) return Container();
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Top Predictions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._prediction!.topPredictions.map(
                  (top) => ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(top.disease ?? "N/A"),
                subtitle: Text(
                    "Probability: ${top.probability != null ? (top.probability! * 100).toStringAsFixed(2) + "%" : "N/A"}"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMedications() {
    if (_prediction!.medications.isEmpty) return Container();
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Suggested Medications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._prediction!.medications.map((med) => Text("• $med", style: const TextStyle(fontSize: 16))),
          ],
        ),
      ),
    );
  }

  Widget _buildConsultDoctor() {
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Consult Doctor: ${_prediction!.consultDoctor ?? "Not available"}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
        ),
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      elevation: 5,
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Additional Recommendations", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("• Follow up with your healthcare provider."),
            Text("• Monitor symptoms regularly."),
            Text("• Stay hydrated and rest."),
          ],
        ),
      ),
    );
  }

  Widget _buildNearbyHelpSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Need Nearby Help?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),

        ElevatedButton.icon(
          icon: const Icon(Icons.local_hospital),
          label: const Text("Find Nearby Help",style: TextStyle(color: Colors.white70),),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: Colors.deepPurple,
          ),
          onPressed: () => _handleNearbySearch(context),
        ),
      ],
    );
  }
}
