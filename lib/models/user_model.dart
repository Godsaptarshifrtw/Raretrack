class UserModel {
  final String uid;
  final String name;
  final String email;
  final String age;
  final String gender;
  final String phone;
  final String? address;
  final String? height;
  final String? weight;
  final String? bmi;
  final List<String>? pastOperations;
  final List<String>? diseases;
  final List<String>? Symptoms;
  final String? Days;



  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
    required this.phone,
    this.bmi,
     this.address,
     this.height,
     this.weight,
     this.pastOperations,
     this.diseases,
     this.Symptoms,
      this.Days,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'phone': phone,
      'bmi': bmi ?? '',
      'address': address ?? '',
      'height': height ?? '',
      'weight': weight ?? '',
      'pastOperations': pastOperations ?? [],
      'diseases': diseases ?? [],
      'Symptoms': Symptoms ?? [],
      'Days': Days ?? '',
    };
  }


  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
      gender: map['gender'],
      bmi: map['bmi'],
      phone: map['phone'],
      address: map['address'],
      height: map['height'],
      weight: map['weight'],
      pastOperations: List<String>.from(map['pastOperations'] ?? []),
      diseases: List<String>.from(map['diseases'] ?? []),
      Symptoms: List<String>.from(map['Symptoms'] ?? []),
      Days: map['Days'],
    );
  }
}
