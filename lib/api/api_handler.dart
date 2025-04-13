import 'dart:convert';

import 'package:http/http.dart' as http;
import '/models/prediction_model.dart';

class ApiHandler{

  Future<PredictionModel> getPredictions({
    required String age,
    required String gender,
    required String duration,
    required List<String> symptoms,
  }) async {
    final url = Uri.parse("https://disease-final-1.onrender.com/predict");

    final body = jsonEncode({
      "age": age,
      "gender": gender,
      "duration": duration,
      "symptoms": symptoms,
    });

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return PredictionModel.fromJson(jsonData);
      } else {
        throw Exception('Failed to get prediction: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting prediction: $e');
    }
  }
}
