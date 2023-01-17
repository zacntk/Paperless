import 'package:flutter/material.dart';

import 'modify.dart';
import 'profile.dart';
import 'approve.dart';
import 'homepage.dart';

class admin_home extends StatefulWidget {
  const admin_home({super.key});

  @override
  State<admin_home> createState() => _admin_home();
}

class _admin_home extends State<admin_home> {
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
                Icons.edit_note,
                size: 40,
              ),
              label: 'แก้ไขข่าวสาร',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.task,
                size: 40,
              ),
              label: 'รออนุมัติ',
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
