import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';
import 'package:flutter_file_structure/sidebar/menu_items.dart' as menu;
import 'package:shared_preferences/shared_preferences.dart';

import '../pages/fifthPage.dart';
import '../pages/fourthPage.dart';
import '../pages/secondPage.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key, required this.menuItems});

  final List<menu.MenuItem> menuItems;

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar>
    with SingleTickerProviderStateMixin<SideBar> {
  late AnimationController? _animationController;
  late StreamController<bool>? isSidebarOpenedStreamController;
  late Stream<bool>? isSidebarOpenedStream;
  late StreamSink<bool>? isSidebarOpenedSink;
  final bool isSideBarOpened = false;
  List<String> docIDs = [];
  final _animationDuration = const Duration(milliseconds: 500);
  String username = '';
  String email = '';

  //get docids
  Future getdocIDS() async {
    DocumentSnapshot ds = await FirebaseFirestore.instance
        .collection('user_details')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get();
    setState(() {
      username = ds.get('username');
      email = ds.get('email');
    });
  }

  @override
  void initState() {
    getdocIDS();

    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: _animationDuration);
    isSidebarOpenedStreamController = PublishSubject<bool>();
    isSidebarOpenedStream = isSidebarOpenedStreamController?.stream;
    isSidebarOpenedSink = isSidebarOpenedStreamController?.sink;
  }

  @override
  void dispose() {
    // TODO: implement initState
    _animationController?.dispose();
    isSidebarOpenedStreamController?.close();
    isSidebarOpenedSink?.close();
    super.dispose();
  }

  void onIconPressed() {
    final animationStatus = _animationController?.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;
    if (isAnimationCompleted) {
      isSidebarOpenedSink?.add(false);
      _animationController?.reverse();
    } else {
      isSidebarOpenedSink?.add(true);
      _animationController?.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSidebarOpenedStream,
      builder: (context, isSideBarOpenedAsync) {
        return AnimatedPositioned(
          duration: _animationDuration,
          top: 0,
          bottom: 0,
          left: (isSideBarOpenedAsync.data ?? false) ? 0 : -screenWidth,
          right: (isSideBarOpenedAsync.data ?? false) ? 0 : screenWidth - 45,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  color: Color(0xFF262AAA),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 100,
                      ),
                      ListTile(
                        title: Text(
                          username,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        subtitle: Text(
                          email,
                          style: TextStyle(
                            color: const Color(0xFF1BB5FD),
                            fontSize: 20,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        leading: CircleAvatar(
                          child: Icon(
                            Icons.perm_identity,
                            color: Colors.white,
                          ),
                          radius: 40,
                        ),
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: const Color(0xFF1BB5FD),
                        indent: 32,
                        endIndent: 32,
                      ),
                      Column(
                        children: widget.menuItems,
                      ),
                      Divider(
                        height: 64,
                        thickness: 0.5,
                        color: const Color(0xFF1BB5FD),
                        indent: 32,
                        endIndent: 32,
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment(0, -0.9),
                child: GestureDetector(
                  onTap: () {
                    onIconPressed();
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Color(0xFF262AAA),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController!.view,
                        icon: AnimatedIcons.menu_close,
                        color: Color(0xFF1BB5FD),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width - 1, height / 2 - 20, width, height / 2);
    path.quadraticBezierTo(width + 1, height / 2 + 20, 10, height - 16);
    path.quadraticBezierTo(0, height - 8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
