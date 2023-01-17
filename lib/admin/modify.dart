import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:paperless/func/firebase_func.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

//รออนุมัติ
class modify extends StatefulWidget {
  const modify({super.key});

  @override
  State<modify> createState() => _modifyState();
}

class _modifyState extends State<modify> {
  final Stream<QuerySnapshot> _historyStream =
      FirebaseFirestore.instance.collection('history').snapshots();
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
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              child: Text(
                "รออนุมัติ",
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _historyStream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              return ListView(
                shrinkWrap: true,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  print(document.id);
                  if (data['status'] == null) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: my_widget(
                        type: data['type'],
                        start_date: data['start_date'].toDate(),
                        end_date: data['end_date'].toDate(),
                        name: data['name'],
                        uid: data['user'],
                        des: data['des'],
                        doc: document.id,
                        remain: data['total'],
                      ),
                    );
                  }
                  return SizedBox(
                    height: 0,
                  );
                }).toList(),
              );
            },
          ),
        ]),
      ),
    );
  }
}

class my_widget extends StatefulWidget {
  const my_widget({
    super.key,
    required this.type,
    required this.start_date,
    required this.end_date,
    required this.name,
    required this.des,
    required this.doc,
    required this.uid,
    required this.remain,
  });

  final String type;
  final DateTime start_date;
  final DateTime end_date;
  final String name;
  final String des;
  final String doc;
  final String uid;
  final int remain;

  @override
  State<my_widget> createState() => _my_widgetState();
}

class _my_widgetState extends State<my_widget> {
  void sendNotification(String token, String title, String body) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAZdrqkw0:APA91bEVpu3HcoCdM03XItzA3xRn0MsWk_lLhdbOm7YwWz63u1erdfiUF6hIWt_htuZo6p7TSycAQdrgE18NP8HMVEIeJAADvxl03F7eXK3hTDsvpuOzktFkva5VWvlz7k1kJmO87o1o'
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'android_channel_id': 'dbfood',
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'status': 'done',
              'body': body,
              'title': title,
            },
            'to': token,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          width: 215.0,
          height: 90.0,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(Color(0xff6C7CB8)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Container(
              width: 500.0,
              height: 90.0,
              decoration: BoxDecoration(color: Color(0xff6C7CB8)),
              child: Row(children: [
                Spacer(),
                Column(
                  children: [
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            "${widget.type}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        Container(
                          child: Text(
                            "${widget.name}",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(
                  flex: 10,
                ),
              ]),
            ),
            onPressed: () {
              Alert(
                context: context,
                title: widget.name,
                desc: widget.des,
                content: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "เริ่ม",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              Text(
                                "${widget.start_date.day}/${widget.start_date.month}/${widget.start_date.year}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.all(20),
                          width: 100,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "จบ",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                              Text(
                                "${widget.end_date.day}/${widget.end_date.month}/${widget.end_date.year}",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ],
                ),
                buttons: [
                  DialogButton(
                      child: Text(
                        "ไม่อนุมัติ",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection("Users")
                            .doc(widget.uid)
                            .get()
                            .then((DocumentSnapshot documentSnapshot) {
                          if (documentSnapshot.exists) {
                            sendNotification(documentSnapshot['token'],
                                "เอกสารการลา", "ไม่อนุมัติ");
                          } else {
                            print('Document does not exist on the database');
                          }
                        });

                        FirebaseFirestore.instance
                            .collection('history')
                            .doc(widget.doc)
                            .update({'status': false});
                        FirebaseFirestore.instance
                            .collection('Users')
                            .doc(widget.uid)
                            .set(
                                {'remain': FieldValue.increment(widget.remain)},
                                SetOptions(merge: true));
                        Navigator.of(context).pop();
                      },
                      color: Colors.red),
                  DialogButton(
                    child: Text(
                      "อนุมัติ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection("Users")
                          .doc(widget.uid)
                          .get()
                          .then((DocumentSnapshot documentSnapshot) {
                        if (documentSnapshot.exists) {
                          sendNotification(documentSnapshot['token'],
                              "เอกสารการลา", "อนุมัติ");
                        } else {
                          print('Document does not exist on the database');
                        }
                      });
                      FirebaseFirestore.instance
                          .collection('history')
                          .doc(widget.doc)
                          .update({'status': true});
                      Navigator.of(context).pop();
                    },
                    color: Colors.green,
                  )
                ],
              ).show();
            },
          ),
        ));
  }
}
