
import 'package:flutter/material.dart';
import 'package:myproject1/screens/account/account.dart';

import 'package:myproject1/screens/category/categories.dart';

import 'package:myproject1/screens/home/home.dart';

class bottomNavigation extends StatefulWidget {
  const bottomNavigation({super.key});

  @override
  State<bottomNavigation> createState() => _bottomNavigationState();
}

class _bottomNavigationState extends State<bottomNavigation> {
  int mycurrentindex = 0;
  List pages = const [
    Homepage(),
    Categories(),
    Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 25,
              offset: const Offset(8, 20))
        ]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BottomNavigationBar(
              backgroundColor: Colors.white,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.black,
              currentIndex: mycurrentindex,
              onTap: (index) {
                setState(() {
                  mycurrentindex = index;
                });
                
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.add), label: 'Category'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_outlined), label: 'Account'),
              ]),
        ),
      ),
      body: pages[mycurrentindex],
    );
  }
}
