import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get currentUser => _firebaseauth.currentUser;

  Stream<User?> get authStateChanges => _firebaseauth.authStateChanges();

  Future<void> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    await _firebaseauth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String username}) async {
    UserCredential userCredential =
        await _firebaseauth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await saveUsernameToDatabase(userCredential.user!.uid, username);
  }

  Future<void> saveUsernameToDatabase(String uid, String username) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username,
      'email': _firebaseauth.currentUser!.email,
    });
  }

  Future<void> signOut() async {
    await _firebaseauth.signOut();
  }

  Future<void> saveUserCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<Map<String, String?>> getUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    return {'email': email, 'password': password};
  }

  Future<void> clearUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email');
    await prefs.remove('password');
  }
}
