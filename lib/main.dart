import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile_application_development_cw1b/providers/user_provider.dart';
import 'package:mobile_application_development_cw1b/screens/login_screen.dart';
import 'package:mobile_application_development_cw1b/screens/news_screen.dart';
import 'providers/news_provider.dart';
import 'package:provider/provider.dart';
import '../service/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: AuthCheck(),
      ),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data == true) {
          return NewsScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }

  Future<bool> _checkLoginStatus(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      try {
        await AuthService()
            .signInWithEmailAndPassword(email: email, password: password);

        final userId = AuthService().currentUser?.uid ?? '';
        if (userId.isNotEmpty) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();

          if (userDoc.exists) {
            final username = userDoc['username'] ?? '';

            Provider.of<UserProvider>(context, listen: false)
                .setUser(userId, username);

            return true;
          }
        }
        return false;
      } catch (e) {
        return false;
      }
    }
    return false;
  }
}
