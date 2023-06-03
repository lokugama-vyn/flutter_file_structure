import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_file_structure/pages/fourthPage.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import 'package:get/get.dart';

import '../controllers/controller.dart';
import '../sidebar/sidebar_layout.dart';

class EndNotify extends StatefulWidget {
  @override
  _EndNotifyState createState() => _EndNotifyState();
}

class _EndNotifyState extends State<EndNotify> {
  Controller controller = Get.find();
  @override
  void initState() {
    FlutterRingtonePlayer.play(fromAsset: "assets/end.mp3");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.4),
      body: Center(
        child: AlertDialog(
          title: Text('Hurray!! Cleaning Finished',
              style: TextStyle(color: Colors.red)),
          content: Text('Know Statistics'),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Ok'),
              onPressed: () {
                FlutterRingtonePlayer.stop();
                // controller.isEnd.value = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SideBarLayout(
                              selected: 0,
                            )));
                controller.isEnd.value = false;
              },
            )
          ],
        ),
      ),
    );
  }
}
