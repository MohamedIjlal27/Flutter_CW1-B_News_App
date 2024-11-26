import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await saveUsernameToDatabase(userCredential.user!.uid, username);
  }

  Future<void> saveUsernameToDatabase(String uid, String username) async {
    await _firestore.collection('users').doc(uid).set({
      'username': username,
      'email': _firebaseAuth.currentUser!.email,
    });
  }

  Future<void> updateUserName(String newUsername) async {
    if (currentUser == null) throw Exception('User not logged in.');

    await _firestore.collection('users').doc(currentUser!.uid).update({
      'username': newUsername,
    });
  }

  Future<void> updateEmail(String newEmail,
      {String? currentPassword, required BuildContext context}) async {
    if (currentUser == null) throw Exception('User not logged in.');

    if (!currentUser!.emailVerified) {
      throw Exception('Please verify your email before updating it.');
    }

    if (currentPassword == null || currentPassword.isEmpty) {
      throw Exception('Password is required for reauthentication.');
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );

      await currentUser!.reauthenticateWithCredential(credential);

      await currentUser!.updateEmail(newEmail);

      await _firestore.collection('users').doc(currentUser!.uid).update({
        'email': newEmail,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email updated successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update email: $e')),
      );
    }
  }

  Future<void> updatePassword(String newPassword,
      {String? currentPassword}) async {
    if (currentUser == null) throw Exception('User not logged in.');

    if (currentPassword != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: currentPassword,
      );
      await currentUser!.reauthenticateWithCredential(credential);
    }

    await currentUser!.updatePassword(newPassword);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
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
