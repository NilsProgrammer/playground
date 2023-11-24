import 'package:firebase_auth/firebase_auth.dart';

class FirebaseLogin {
  static Future<User> login(String email, String password) async {

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    while (FirebaseAuth.instance.currentUser == null) {
      await Future.delayed(const Duration(milliseconds: 100));
    }

    User me = FirebaseAuth.instance.currentUser!;

    return me;
  }

  static Future<void> logout() async {
    return FirebaseAuth.instance.signOut();
  }

  static Future<void> deleteUser() async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.delete();
  }
}