import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      home: SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final nameController = TextEditingController();
  final nimController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    nimController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          child: Center(child: 
            Text('Daftar', 
            style: GoogleFonts.acme(
          
          
          ),)),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textBox('Nama', nameController, false, TextInputType.name),
                  textBox('Nim', nimController, false, TextInputType.number),
                  textBox('No HP', phoneNumberController, false,
                      TextInputType.phone),
                  textBox('Email', emailController, false,
                      TextInputType.emailAddress),
                  textBox('Kata Sandi', passwordController, true,
                      TextInputType.text),
                  ElevatedButton(
                    onPressed: () {
                      signUpEmailPassword(
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          nimController.text,
                          phoneNumberController.text);
                    },
                    child: Text('Daftar'),
                    style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 40)),
                  ),

                  Text('Sudah Punya Akun?'),
                  SizedBox(
                    height: 12,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Masuk'),
                    style: ElevatedButton.styleFrom(
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        minimumSize: Size(double.infinity, 20)),
                  ),
                  SizedBox(
                    height: 24,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Column textBox(String title, TextEditingController controller,
      bool obscureText, TextInputType type) {
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
}

Future<User?> signUpEmailPassword(
  String email,
  String password,
  String name,
  String nim,
  String phoneNumber,
) async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  try {
    UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    db.collection('users').doc(credential.user?.uid).set({
      'name': name,
      'nim': nim,
      'phoneNumber': phoneNumber,
      'email': email,
    });
    Fluttertoast.showToast(msg: 'Berhasil membuat akun');
    return credential.user;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') {
      Fluttertoast.showToast(msg: 'Email sudah digunakan');
    } else {
      Fluttertoast.showToast(msg: 'Telah terjadi kesalahan : ${e.code}');
    }
  }

  return null;
}