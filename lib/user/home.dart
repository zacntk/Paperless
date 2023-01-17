import 'package:flutter/material.dart';

import 'modify.dart';
import 'profile.dart';
import 'approve.dart';
import 'homepage.dart';

class user_home extends StatefulWidget {
  const user_home({super.key});

  @override
  State<user_home> createState() => _user_home();
}

class _user_home extends State<user_home> {
  int currentIndex = 0;

  final tabs = [homepage(), Approve(), modify(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentIndex],
      backgroundColor: const Color(0xffDFE6F6),
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xff6C7CB8),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 40,
              ),
              label: 'หน้าหลัก',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.history,
                size: 40,
              ),
              label: 'ประวัติ',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.note_add,
                size: 40,
              ),
              label: 'สร้างเอกสาร',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 40,
              ),
              label: 'ฉัน',
            ),
          ]),
    );
  }
}
