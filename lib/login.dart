import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'func/login_func.dart';

class loginPage extends StatefulWidget {
  const loginPage({super.key});

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  late TextEditingController email_controller;
  late TextEditingController password_controller;

  @override
  void initState() {
    super.initState();
    email_controller = TextEditingController();
    password_controller = TextEditingController();
  }

  @override
  void dispose() {
    email_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff6C7CB8),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
              margin: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Paperless",
                        style: TextStyle(
                            fontFamily: 'Angelina',
                            fontSize: 100,
                            color: Colors.white),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ), //Name App:  paperless
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Username",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(),
                    ],
                  ), //Username
                  Column(
                    children: [
                      TextField(
                        controller: email_controller,
                        decoration: InputDecoration(
                            hintText: "Your Username",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.person)),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  ), //input ID
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Align(),
                    ],
                  ), //password
                  Column(
                    children: [
                      TextField(
                        obscureText: true,
                        controller: password_controller,
                        decoration: InputDecoration(
                            hintText: "Your Password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none),
                            fillColor: Colors.white,
                            filled: true,
                            prefixIcon: Icon(Icons.lock_outline)),
                      ),
                      SizedBox(
                        height: 50,
                      ),

                      //ปุ่ม login
                      ElevatedButton(
                        onPressed: () {
                          login(email_controller.text, password_controller.text)
                              .then((value) => {
                                    FirebaseMessaging.instance
                                        .getToken()
                                        .then((token) => {
                                              FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(FirebaseAuth.instance
                                                      .currentUser?.uid)
                                                  .set({
                                                'token': token,
                                              }, SetOptions(merge: true))
                                            })
                                  });
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  ) //input Password
                ],
              )),
        ),
      ),
    );
  }
}
