import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:http/http.dart' as http;

class modify extends StatefulWidget {
  const modify({super.key});

  @override
  State<modify> createState() => _modifyState();
}

class _modifyState extends State<modify> {
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

  final user = FirebaseAuth.instance.currentUser?.uid;
  int remain = 0;
  String token = "";
  String name = "";
  String EndDate = "โปรดระบุวันสิ้นสุด";
  String StartDate = 'โปรดระบุวันที่เริ่ม';
  DateTime start_date = DateTime.now();
  DateTime end_date = DateTime.now();
  TextEditingController desController = TextEditingController();

  int counter = 0;
  final List<String> items = [
    'ลาป่วย',
    'ลากิจ',
    'ลาคลอด',
    'ลาบวช',
    'ลาพักร้อน',
  ];
  String? selectedValue;
  final buttonWidth = 300.0;
  final buttonHeight = 50.0;

  @override
  void initState() {
    super.initState();
    desController = TextEditingController();
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
          token = documentSnapshot['token'];
        });
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  void dispose() {
    desController.dispose();
    super.dispose();
  }

  void StartDatePicker(BuildContext context) {
    BottomPicker.date(
      title: 'Set Date',
      dateOrder: DatePickerDateOrder.dmy,
      pickerTextStyle: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Color.fromARGB(255, 76, 98, 240),
      ),
      onSubmit: (index) {
        setState(() {
          start_date = DateUtils.dateOnly(index);
          StartDate = DateFormat.yMMMd().format(index);
        });
        print(index);
      },
      bottomPickerTheme: BottomPickerTheme.plumPlate,
    ).show(context);
  }

  void EndDatePicker(BuildContext context) {
    BottomPicker.date(
      title: 'Set Date',
      dateOrder: DatePickerDateOrder.dmy,
      pickerTextStyle: TextStyle(
        color: Color.fromARGB(255, 0, 0, 0),
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Color.fromARGB(255, 76, 98, 240),
      ),
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      onSubmit: (index) {
        setState(() {
          end_date = DateUtils.dateOnly(index);
          EndDate = DateFormat.yMMMd().format(index);
        });
        print(index);
      },
    ).show(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffDFE6F6),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background_2.png'),
                    fit: BoxFit.contain,
                    colorFilter: ColorFilter.mode(
                        Color.fromRGBO(223, 230, 246, 0.2),
                        BlendMode.dstATop))),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(right: 110.0),
                  child: Container(
                    child: Text(
                      "สร้างเอกสารการลา",
                      style: TextStyle(
                          fontSize: 28.0, fontWeight: FontWeight.bold),
                    ),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                  ),
                ),
                Container(
                  width: 1000,
                  height: 60,
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      isExpanded: true,
                      hint: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'โปรดระบุหัวข้อการลา',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      items: items
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_drop_down,
                      ),
                      iconSize: 25,
                      iconEnabledColor: Colors.black,
                      iconDisabledColor: Colors.grey,
                      buttonHeight: 50,
                      buttonWidth: 300,
                      buttonPadding: const EdgeInsets.only(left: 14, right: 14),
                      buttonDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.black,
                          width: 2,
                        ),
                        color: Colors.indigo.shade100,
                      ),
                      buttonElevation: 2,
                      itemHeight: 40,
                      itemPadding: const EdgeInsets.only(
                        left: 14,
                        right: 14,
                      ),
                      dropdownMaxHeight: 300,
                      dropdownWidth: 372,
                      dropdownPadding: null,
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        ),
                        color: Colors.white,
                      ),
                      dropdownElevation: 8,
                      scrollbarRadius: const Radius.circular(40),
                      scrollbarThickness: 6,
                      scrollbarAlwaysShow: true,
                      offset: const Offset(0, 0),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 1000,
                  height: 60,
                  child: SizedBox(
                    height: buttonHeight,
                    width: buttonWidth,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.indigo.shade100),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          StartDatePicker(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            StartDate,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 1000,
                  height: 60,
                  child: SizedBox(
                    height: buttonHeight,
                    width: buttonWidth,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.indigo.shade100),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            side: BorderSide(width: 2, color: Colors.black),
                          ),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          EndDatePicker(context);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            EndDate,
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: desController,
                  keyboardType: TextInputType.emailAddress,
                  maxLines: 12,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    hintText: 'เขียนคำอธิบายเพิ่มเติม',
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(
                        width: 3,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: 150.0,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.indigo.shade100),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(width: 3, color: Colors.black),
                        ),
                      ),
                    ),
                    child: Text(
                      'ส่งเอกสาร',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    onPressed: () {
                      print(start_date);
                      print(end_date);
                      print(selectedValue);
                      print(desController.text);
                      print(end_date.difference(start_date).inDays + 1);
                      if (StartDate == 'เลือกวันที่เริ่มต้น' ||
                          EndDate == 'เลือกวันที่สิ้นสุด' ||
                          selectedValue == 'เลือกประเภทเอกสาร' ||
                          desController.text == '') {
                        Alert(
                          context: context,
                          type: AlertType.error,
                          title: "Error",
                          desc: "กรุณากรอกข้อมูลให้ครบถ้วน",
                          buttons: [
                            DialogButton(
                              child: Text(
                                "ตกลง",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () => Navigator.pop(context),
                            )
                          ],
                        ).show();
                      } else {
                        if (end_date.difference(start_date).inDays + 1 >
                            remain) {
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: "Error",
                            desc: "วันลาเกินกำหนด",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "ตกลง",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                              )
                            ],
                          ).show();
                        } else {
                          Alert(
                            context: context,
                            type: AlertType.warning,
                            title: "ยืนยันการส่งเอกสาร",
                            desc: "คุณต้องการส่งเอกสารใช่หรือไม่",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "ยกเลิก",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                              ),
                              DialogButton(
                                child: Text(
                                  "ยืนยัน",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('Users')
                                      .doc(user)
                                      .set({
                                    'remain': remain -
                                        (end_date.difference(start_date).inDays)
                                  }, SetOptions(merge: true));
                                  FirebaseFirestore.instance
                                      .collection('history')
                                      .add({
                                    'type': selectedValue,
                                    'des': desController.text,
                                    'start_date': start_date,
                                    'end_date': end_date,
                                    'user': user,
                                    'name': name,
                                    'total':
                                        end_date.difference(start_date).inDays +
                                            1,
                                  }).then((value) {
                                    FirebaseFirestore.instance
                                        .collection("Users")
                                        .doc("6cnOISlhRyXOI3sJw15ZLlhmwGl1")
                                        .get()
                                        .then((DocumentSnapshot
                                            documentSnapshot) {
                                      if (documentSnapshot.exists) {
                                        sendNotification(
                                            documentSnapshot['token'],
                                            'มีเอกสารใหม่',
                                            'มีเอกสารใหม่จาก $name');
                                      } else {
                                        print(
                                            'Document does not exist on the database');
                                      }
                                    });
                                    Navigator.of(context).pop();
                                    Alert(
                                      context: context,
                                      type: AlertType.success,
                                      title: "ส่งเอกสารสำเร็จ",
                                      desc: "คุณได้ส่งเอกสารเรียบร้อยแล้ว",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "ตกลง",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ).show();
                                  }).catchError((error) {
                                    Navigator.of(context).pop();
                                    Alert(
                                      context: context,
                                      type: AlertType.error,
                                      title: "Error",
                                      desc: "มีบางอย่างผิดพลาด",
                                      buttons: [
                                        DialogButton(
                                          child: Text(
                                            "ตกลง",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        )
                                      ],
                                    ).show();
                                  });
                                },
                              ),
                            ],
                          ).show();
                        }
                      }
                    },
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
