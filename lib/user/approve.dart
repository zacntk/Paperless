import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Approve extends StatefulWidget {
  const Approve({super.key});

  @override
  State<Approve> createState() => _ApproveState();
}

class _ApproveState extends State<Approve> {
  final Stream<QuerySnapshot> _historyStream =
      FirebaseFirestore.instance.collection('history').snapshots();
  final user = FirebaseAuth.instance.currentUser?.uid;
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
                "ประวัติการลา",
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
                  print(data);
                  if (data['user'] == user) {
                    if (data['status'] != null) {
                      if (data['status']) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: my_widget(
                              type: data['type'],
                              start_date: data['start_date'].toDate(),
                              end_date: data['end_date'].toDate(),
                              status: data['status'],
                              color: Colors.green),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: my_widget(
                              type: data['type'],
                              start_date: data['start_date'].toDate(),
                              end_date: data['end_date'].toDate(),
                              status: data['status'],
                              color: Colors.red),
                        );
                      }
                    }
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
  const my_widget(
      {super.key,
      required this.type,
      required this.start_date,
      required this.end_date,
      required this.status,
      required this.color});

  final String type;
  final DateTime start_date;
  final DateTime end_date;
  final bool status;
  final Color color;

  @override
  State<my_widget> createState() => _my_widgetState();
}

class _my_widgetState extends State<my_widget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          width: 215.0,
          height: 90.0,
          child: ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(widget.color),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Container(
              width: 500.0,
              height: 90.0,
              decoration: BoxDecoration(color: widget.color),
              child: Row(
                children: [
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
                              "${widget.start_date.day}/${widget.start_date.month}/${widget.start_date.year} - ${widget.end_date.day}/${widget.end_date.month}/${widget.end_date.year}",
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
                  Column(
                    children: [
                      Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              "สถานะ",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Icon(
                              widget.status
                                  ? Icons.check_circle_outline_sharp
                                  : Icons.cancel_outlined,
                              color: Colors.white,
                              size: 15.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                          ),
                        ],
                      ),
                      Spacer()
                    ],
                  ),
                  Spacer()
                ],
              ),
            ),
            onPressed: () {
              print("Hello");
            },
          ),
        ));
  }
}
