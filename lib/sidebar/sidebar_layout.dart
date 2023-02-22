import 'package:flutter/material.dart';
import 'package:flutter_file_structure/pages/fifthPage.dart';
import 'package:flutter_file_structure/pages/thirdPage.dart';
import 'package:flutter_file_structure/sidebar/menu_items.dart' as menu;

import '../pages/fourthPage.dart';
import '../pages/secondPage.dart';
import 'sidebar.dart';

class SideBarLayout extends StatefulWidget {
  const SideBarLayout({super.key});

  @override
  State<SideBarLayout> createState() => SideBarLayoutState();
}

class SideBarLayoutState extends State<SideBarLayout> {
  var pages = [
    thirdPage(title: "Monitoring Panel"),
    fourthPage(),
    fifthPage(),
  ];
  var selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          pages[selectedPage],
          SideBar(menuItems: [
            menu.MenuItem(
              icon: Icons.monitor_outlined,
              title: "Monitoring Panel",
              onTap: () {
                setState(() {
                  selectedPage = 0;
                });
              },
            ),
            menu.MenuItem(
              icon: Icons.swipe_left,
              title: "Manual Control",
              onTap: () {
                setState(() {
                  selectedPage = 1;
                });
              },
            ),
            menu.MenuItem(
              icon: Icons.exit_to_app,
              title: "Logout",
              onTap: () {
                setState(() {
                  selectedPage = 2;
                });
              },
            ),
          ]),
        ],
      ),
    );
  }
}
