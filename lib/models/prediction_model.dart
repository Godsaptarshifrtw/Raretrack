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

  factory PredictionModel.fromJson(Map<String, dynamic> json){
    return PredictionModel(
      predictedDisease: json["predicted_disease"],
      probability: json["probability"],
      topPredictions: json["top_predictions"] == null ? [] : List<TopPrediction>.from(json["top_predictions"]!.map((x) => TopPrediction.fromJson(x))),
      medications: json["medications"] == null ? [] : List<String>.from(json["medications"]!.map((x) => x)),
      consultDoctor: json["consult_doctor"],
    );
  }

}

class TopPrediction {
  TopPrediction({
    required this.disease,
    required this.probability,
  });

  final String? disease;
  final double? probability;

  factory TopPrediction.fromJson(Map<String, dynamic> json){
    return TopPrediction(
      disease: json["disease"],
      probability: json["probability"],
    );
  }

}
