import 'package:flutter/material.dart';
import 'screens/login_page.dart';
import 'screens/signup_page.dart';

void main() {
  runApp(const HostelAuthApp());
}

class HostelAuthApp extends StatelessWidget {
  const HostelAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/signup': (context) => SignupPage(),
      },
    );
  }
}
