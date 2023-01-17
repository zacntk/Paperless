import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../login.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser?.uid;
  late String name = "";
  late int remain = 0;

  @override
  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('Users')
        .doc(user)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
        setState(() {
          name = documentSnapshot['name'];
          remain = documentSnapshot['remain'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDFE6F6),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/background_2.png'),
                fit: BoxFit.contain,
                colorFilter: ColorFilter.mode(
                    Color.fromRGBO(223, 230, 246, 0.2), BlendMode.dstATop))),
        child: Column(
          children: [
            Center(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 50,
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: AssetImage('assets/proflie.jpg'),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 40),
                              child: Text('${name}',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontFamily: 'PridiRegular')),
                            )
                          ],
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                            padding: const EdgeInsets.only(left: 30, top: 45),
                            child: Text.rich(TextSpan(children: <TextSpan>[
                              TextSpan(
                                  text: 'จำนวนวันลาคงเหลือ ${remain} วัน',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 25,
                                      fontFamily: 'Kanit',
                                      fontWeight: FontWeight.bold,
                                      wordSpacing: 30)),
                            ])))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(20.0)),
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
        },
        label: Text(
          'ออกจากระบบ',
          style: TextStyle(
              color: Colors.black, fontSize: 18, fontFamily: 'PridiRegular'),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
