import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:playground/views/home_page.dart';
import 'package:playground/views/login_page.dart';

class LoginRedirectPage extends StatefulWidget {
  const LoginRedirectPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginRedirectPageState();

}

class _LoginRedirectPageState extends State<LoginRedirectPage> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser != null
    ? const HomePage()
    : StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, user) {
        User? current = FirebaseAuth.instance.currentUser;

        if (current == null) {
            return const LoginPage();
        }

        return const HomePage();
      }
    );
  }

}