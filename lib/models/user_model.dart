class UserModel {
  final String uid;
  final String name;
  final String email;
  final String age;
  final String gender;
  final String? address;
  final String? height;
  final String? weight;
  final List<String>? pastOperations;
  final List<String>? diseases;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.age,
    required this.gender,
     this.address,
     this.height,
     this.weight,
     this.pastOperations,
     this.diseases,
  });


  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'age': age,
      'gender': gender,
      'address': address ?? '',
      'height': height ?? '',
      'weight': weight ?? '',
      'pastOperations': pastOperations ?? [],
      'diseases': diseases ?? [],
    };
  }


  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      age: map['age'],
      gender: map['gender'],
      address: map['address'],
      height: map['height'],
      weight: map['weight'],
      pastOperations: List<String>.from(map['pastOperations'] ?? []),
      diseases: List<String>.from(map['diseases'] ?? []),
    );
  }
}
