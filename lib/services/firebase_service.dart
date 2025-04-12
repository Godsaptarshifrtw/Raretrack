import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String name,
    required String email,
    required String password,
    required String age,
    required String gender,
    required String phone
  }) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;
      if (user != null) {
        UserModel newUser = UserModel(
          uid: user.uid,
          name: name,
          email: email,
          age: age,
          gender: gender,
          phone: phone,
        );

        await _firestore.collection('Users').doc(user.uid).set(newUser.toMap());
        return null; // success
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.message}");
      return e.message;
    } catch (e) {
      print("Firestore Error: $e");
      return "Something went wrong while saving user data.";
    }
  }




  Future<UserCredential?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print('Login Error: ${e.code} - ${e.message}');
      return null;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
  }


  User? get currentUser => _auth.currentUser;
}
