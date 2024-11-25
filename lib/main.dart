import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:my_news_app/screens/login_screen.dart';
import 'package:my_news_app/screens/news_screen.dart';
import 'providers/news_provider.dart';
import 'package:provider/provider.dart';
import '../service/auth.dart';

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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'News App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: _checkLoginStatus(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data == true) {
              return NewsScreen(); // User is logged in
            } else {
              return const LoginScreen(); // User is not logged in
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkLoginStatus() async {
    final credentials = await AuthService().getUserCredentials();
    if (credentials['email'] != null && credentials['password'] != null) {
      try {
        await AuthService().signInWithEmailAndPassword(
          email: credentials['email']!,
          password: credentials['password']!,
        );
        return true; // Successfully logged in
      } catch (e) {
        return false; // Failed to log in
      }
    }
    return false; // No credentials found
  }
}
