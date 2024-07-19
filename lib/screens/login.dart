import 'package:firebase_auth/firebase_auth.dart';
import 'package:loginbelajar_hafiz/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Login(),
    );
  }
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Selamat datang",
                    style: GoogleFonts.acme(
                      fontSize: 25,
                      letterSpacing: 1,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "di Aplikasi Muhammad Hafiz Ansyari",
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  textBox('Email', emailController, false,
                      TextInputType.emailAddress),
                  textBox('Kata Sandi', passwordController, true,
                      TextInputType.text),
                  ElevatedButton(
                    onPressed: () async {
                      User? user = await loginEmailPassword(
                          emailController.text, passwordController.text);

                      if (user != null) {
                        print(user.uid);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Home(id: user.uid)));

                      }
                    },
                    child: Text('Masuk'),
                    style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 40)),
                  ),
                  SizedBox(
                    height: 28,
                  ),
                  Text('Belum Punya Akun?'),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    child: Text('Daftar'),
                    style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 40)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Column textBox(String title, TextEditingController controller, bool obscureText,
    TextInputType type) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title,
        style: TextStyle(fontSize: 16),
      ),
      TextField(
        obscureText: obscureText,
        keyboardType: type,
        controller: controller,
        decoration: InputDecoration(border: OutlineInputBorder()),
      ),
      SizedBox(
        height: 18,
      )
    ],
  );
}

Future<User?> loginEmailPassword(String email, String password) async {
  FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    print(credential.user);

    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      Fluttertoast.showToast(msg: 'Invalid email or password');
    } else {
      Fluttertoast.showToast(msg: 'Telah terjadi kesalahan : ${e.code}');
    }
  }

  return null;
}