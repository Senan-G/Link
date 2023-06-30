import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:link/services/notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'MainPages/all.dart';

import 'SubPages/LinkPage.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => HomeState();
}

/// This is the private State class that goes with MyStatefulWidget.
class HomeState extends State<Home> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  PageController pageController = PageController(
    initialPage: 1,
    keepPage: true,
  );

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: const <Widget>[
        Links(),
        MapPage(),
        Profile(),
      ],
    );
  }

  @override
  void initState() {
    NotificationHandler().requestNotification();
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {


    return OverlaySupport.global(
      child: Scaffold(
        body: Center(
          child:  buildPageView(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[

            BottomNavigationBarItem(
              icon: Icon(Icons.link),
              label: 'Links',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.lightBlue,
          unselectedItemColor: Colors.black38,
          onTap: (index) {
            bottomTapped(index);
          },
        ),
      ),
    );
  }
}