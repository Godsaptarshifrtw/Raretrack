enum SymptomSeverity { mild, moderate, severe }

class PatientRecord {
  final String patientId;
  final String age;
  final String gender;
  final List<String> symptomName;
  final List<SymptomSeverity> symptomSeverity; // Use enum list
  final DateTime symptomOnsetDate;
  final DateTime logDate;
  final String? medicationName;
  final String? medicationDose;
  final String outcome;
  final String moodPainScore;
  final DateTime? doctorVisitDate;
  final String? diagnosticsTests;

  PatientRecord({
    required this.patientId,
    required this.age,
    required this.gender,
    required this.symptomName,
    required this.symptomSeverity,
    required this.symptomOnsetDate,
    required this.logDate,
    this.medicationName,
    this.medicationDose,
    required this.outcome,
    required this.moodPainScore,
    this.doctorVisitDate,
    this.diagnosticsTests,
  });

  factory PatientRecord.fromJson(Map<String, dynamic> json) {
    final symptomName = json['symptom_name'] is String
        ? (json['symptom_name'] as String).split(', ')
        : List<String>.from(json['symptom_name'] ?? []);
    final symptomSeverity = json['symptom_severity'] is String
        ? (json['symptom_severity'] as String)
            .split(', ')
            .map((s) => SymptomSeverity.values.firstWhere(
                  (e) => e.toString().split('.').last == s,
                  orElse: () => SymptomSeverity.mild,
                ))
            .toList()
        : List<SymptomSeverity>.from(json['symptom_severity']?.map((s) => SymptomSeverity.values.byName(s)) ?? []);

    return PatientRecord(
      patientId: json['patient_id'] as String? ?? '',
      age: json['age'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      symptomName: symptomName,
      symptomSeverity: symptomSeverity,
      symptomOnsetDate: DateTime.parse(json['symptom_onset_date'] as String? ?? DateTime.now().toIso8601String()),
      logDate: DateTime.parse(json['log_date'] as String? ?? DateTime.now().toIso8601String()),
      medicationName: json['medication_name'] as String?,
      medicationDose: json['medication_dose'] as String?,
      outcome: json['outcome'] as String? ?? '',
      moodPainScore: json['mood_pain_score'] as String? ?? '',
      doctorVisitDate: json['doctor_visit_date'] != null
          ? DateTime.parse(json['doctor_visit_date'] as String)
          : null,
      diagnosticsTests: json['diagnostics_tests'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patient_id': patientId,
      'age': age,
      'gender': gender,
      'symptom_name': symptomName.join(', '),
      'symptom_severity': symptomSeverity.map((s) => s.toString().split('.').last).join(', '),
      'symptom_onset_date': symptomOnsetDate.toIso8601String(),
      'log_date': logDate.toIso8601String(),
      'medication_name': medicationName,
      'medication_dose': medicationDose,
      'outcome': outcome,
      'mood_pain_score': moodPainScore,
      'doctor_visit_date': doctorVisitDate?.toIso8601String(),
      'diagnostics_tests': diagnosticsTests,
    };
  }
}