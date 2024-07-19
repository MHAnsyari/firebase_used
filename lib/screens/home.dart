import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  final String id;

  const Home({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: FutureBuilder<DocumentSnapshot>(
                future:
                    FirebaseFirestore.instance.collection('users').doc(id).get(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
        
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Text('Loading....');
        
                    default:
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Selamat Anda Berhasil Login'),
                                SizedBox(
                                  height: 12,
                                ),
                                Text('Nama : ${data['name']}'),
                                SizedBox(
                                  height: 12,
                                ),
                                Text('Nim : ${data['nim']}'),
                                SizedBox(
                                  height: 12,
                                ),
                                Text('No HP : ${data['phoneNumber']}'),
                                SizedBox(
                                  height: 12,
                                ),
                                Text('Email : ${data['email']}'),
                                SizedBox(
                                  height: 100,
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Keluar'),
                              style: ElevatedButton.styleFrom(
                                  shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  minimumSize: Size(double.infinity, 40)),
                            ),
                          ],
                        ),
                      );
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}