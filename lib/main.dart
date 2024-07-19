import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:loginbelajar_hafiz/screens/login.dart';
import 'package:loginbelajar_hafiz/screens/signup.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const Login(),
      '/signup': (context) => const SignUp(),
    },
  ));
}