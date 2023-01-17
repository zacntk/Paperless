import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  TextEditingController? controller_Header1, controller_Info1;
  File? imageFile1;
  final storageRef = FirebaseStorage.instance.ref().child("news-image");
  final metadata = SettableMetadata(contentType: "image/jpeg");
  CollectionReference News = FirebaseFirestore.instance.collection('News');
  final Stream<QuerySnapshot> _historyStream =
      FirebaseFirestore.instance.collection('News').snapshots();

  /// Get from gallery
  _getFromGallery() async {
    PickedFile? pickedFile1 = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile1 != null) {
      setState(() {
        imageFile1 = File(pickedFile1.path);
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller_Header1 = TextEditingController();
    controller_Info1 = TextEditingController();
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
        child: ListView(children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Container(
              child: Text(
                "ข่าวสาร",
                style: TextStyle(fontSize: 26.0, fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.all(10),
            ),
          ),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff6C7CB8)),
                  onPressed: () {
                    Alert(
                      context: context,
                      image: imageFile1 == null
                          ? Image.asset('assets/background_2.png')
                          : Image.file(imageFile1!, fit: BoxFit.cover),
                      content: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              _getFromGallery();
                            },
                            child: Text("เลือกรูป"),
                          ),
                          TextField(
                            controller: controller_Header1,
                            decoration: InputDecoration(
                              icon: Icon(Icons.title),
                              labelText: 'หัวข้อ',
                            ),
                          ),
                          TextField(
                            controller: controller_Info1,
                            decoration: InputDecoration(
                              icon: Icon(Icons.info),
                              labelText: 'รายละเอียด',
                            ),
                          ),
                        ],
                      ),
                      buttons: [
                        DialogButton(
                            child: Text(
                              "เพิ่มข้อมูล",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            onPressed: () {
                              final uploadTask = storageRef
                                  .child(basename(imageFile1!.path))
                                  .putFile(imageFile1!, metadata);
                              uploadTask.snapshotEvents
                                  .listen((TaskSnapshot taskSnapshot) {
                                switch (taskSnapshot.state) {
                                  case TaskState.running:
                                    final progress = 100.0 *
                                        (taskSnapshot.bytesTransferred /
                                            taskSnapshot.totalBytes);
                                    print("Upload is $progress% complete.");
                                    break;
                                  case TaskState.paused:
                                    print("Upload is paused.");
                                    break;
                                  case TaskState.canceled:
                                    print("Upload was canceled");
                                    break;
                                  case TaskState.error:
                                    // Handle unsuccessful uploads
                                    break;
                                  case TaskState.success:
                                    // Handle successful uploads on complete
                                    News.doc(controller_Header1!.text)
                                        .set(
                                          {
                                            'title': controller_Header1!.text,
                                            'subtitle': controller_Info1!.text,
                                            'image': basename(imageFile1!.path),
                                          },
                                          SetOptions(merge: true),
                                        )
                                        .then((value) => print("News Added"))
                                        .catchError((error) => print(
                                            "Failed to add news: $error"));
                                    Navigator.of(context).pop();
                                    break;
                                }
                              });
                            },
                            color: Colors.green),
                      ],
                    ).show();
                  },
                  child: const Icon(Icons.add))),
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
                  return Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    child: my_widget(
                      title: data['title'],
                      subtitle: data['subtitle'],
                      image: data['image'],
                    ),
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
      required this.title,
      required this.subtitle,
      required this.image});

  final String title;
  final String subtitle;
  final String image;

  @override
  State<my_widget> createState() => _my_widgetState();
}

class _my_widgetState extends State<my_widget> {
  loadimage(String name) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child('news-image/$name');
    String url = await ref.getDownloadURL();
    setState(() {
      pic = url;
    });
  }

  String pic = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadimage(widget.image);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: SizedBox(
        width: 215.0,
        height: 180.0,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          child: Container(
            width: 500.0,
            height: 180.0,
            decoration: BoxDecoration(color: Colors.green),
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
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white, width: 3),
                            image: DecorationImage(
                              image: pic != ""
                                  ? Image.network(pic).image
                                  : AssetImage('assets/background_2.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                Spacer(
                  flex: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 160,
                      height: 70,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "${widget.title}",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Container(
                      width: 160,
                      height: 100,
                      padding: EdgeInsets.all(8),
                      child: Text(
                        "${widget.subtitle}",
                        style: TextStyle(fontSize: 15),
                        textAlign: TextAlign.end,
                      ),
                    ),
                    Spacer()
                  ],
                ),
                Spacer()
              ],
            ),
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
