import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

class test_page extends StatefulWidget {
  const test_page({super.key});

  @override
  State<test_page> createState() => _test_pageState();
}

class _test_pageState extends State<test_page> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  TextEditingController username = TextEditingController();
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  @override
  initState() {
    super.initState();
    requestPermission();
    getToken();
    initInfo();
  }

  initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("..................onMessage....................");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        importance: Importance.high,
        priority: Priority.high,
        styleInformation: bigTextStyleInformation,
        playSound: false,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpecifics,
          payload: message.data['body']);
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) => {print(token)});
  }

  void saveToken(String token) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection('users')
        .doc(username.text)
        .set({'token': token})
        .then((value) => print("success"))
        .catchError((error) => print("Failed : $error"));
  }

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
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: username,
              decoration: InputDecoration(
                hintText: 'username',
              ),
            ),
            TextField(
              controller: title,
              decoration: InputDecoration(
                hintText: 'title',
              ),
            ),
            TextField(
              controller: body,
              decoration: InputDecoration(
                hintText: 'body',
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                String name = username.text.trim();
                String titleText = title.text;
                String bodyText = body.text;

                if (name != "") {
                  // FirebaseFirestore db = FirebaseFirestore.instance;
                  // db
                  //     .collection('users')
                  //     .doc(name)
                  //     .get()
                  //     .then((DocumentSnapshot documentSnapshot) {
                  //   if (documentSnapshot.exists) {
                  //     print('Document data: ${documentSnapshot.data()}');
                  //     String token = documentSnapshot['token'];
                  //     sendNotification(token, titleText, bodyText);
                  //   } else {
                  //     print('Document does not exist on the database');
                  //   }
                  // });
                  sendNotification(
                      "ez6-PbN_RLeX4LC-3YJIMr:APA91bFfmECRROelyqaw5c2v0NgHLO3FkTw2y5tNz8wkvY_6JAGM97FqUQRMunqlfYGpssKbLvMDc8CWNzGgIE6cSVWIaXw6t6g49RxdxVVTwbmWiE13km7EmDXiFj7ETSZ8ieojTRwR",
                      titleText,
                      bodyText);
                }
              },
              child: Text('send'),
            ),
          ],
        ),
      ),
    );
  }
}
