import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_file_structure/pages/fourthPage.dart';
import 'package:flutter_file_structure/sidebar/sidebar_layout.dart';

import 'package:get/get.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import '../controllers/controller.dart';

class ErrorPage extends StatefulWidget {
  @override
  _ErrorPageState createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  Controller controller = Get.find();
  @override
  void initState() {
    FlutterRingtonePlayer.play(fromAsset: "assets/alarm.mp3");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.4),
      body: Center(
        child: AlertDialog(
          title: Text('Warning! Warning!', style: TextStyle(color: Colors.red)),
          content: Obx(() {
            return Text(controller.userWarning.value);
          }),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Take Control'),
              onPressed: () {
                FlutterRingtonePlayer.stop();
                print(controller.isError.value);
                controller.isError.value = false;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SideBarLayout(
                              selected: 1,
                            ))); //changed to sidebarlayout from fourthpage
              },
            )
          ],
        ),
      ),
    );
  }
}
