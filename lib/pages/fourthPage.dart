import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_file_structure/controllers/controller.dart';
import 'package:get/get.dart';
import 'package:roslibdart/roslibdart.dart';
import 'package:vibration/vibration.dart';

import 'EndNotify.dart';
import 'ErrorPage.dart';

class fourthPage extends StatefulWidget {
  @override
  _fourthPageState createState() => _fourthPageState();
}

class _fourthPageState extends State<fourthPage> {
  late Ros ros;
  late Topic manualControl;

  //added states to recognize pressed buttons
  bool forwardState = false;
  bool reverseState = false;
  bool rightState = false;
  bool leftState = false;
  bool movingState = false;
  Controller controller = Get.find();
  @override
  void initState() {
    ros = Ros(url: 'wss://solarpanelcleaningrobot.pagekite.me/');
    manualControl = Topic(
        ros: ros,
        name: '/manualControl',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    super.initState();
  }

  void initConnection() async {
    ros.connect();

    await manualControl.advertise();

    setState(() {});
  }

  void forward_func() async {
    //change code to continously press button
    setState(() {
      forwardState = true;
      reverseState = false;
      rightState = false;
      leftState = false;
      movingState = true;
    });
    Vibration.vibrate(pattern: [500, 1000, 500, 2000], intensities: [1, 255]);

    var msg = {'data': 'f'};
    await manualControl.publish(msg);
    // print('cmd published');
    // print('done publihsed forward topic');
  }

  void forwardRelease_func() async {
    //change code to continously press button

    var msg = {'data': 'z'};
    await manualControl.publish(msg);
    // print('cmd published');
    // print('done publihsed forward topic');
  }

  void backward_func() async {
    setState(() {
      forwardState = false;
      reverseState = true;
      rightState = false;
      leftState = false;
      movingState = true;
    });
    Vibration.vibrate(pattern: [500, 1000, 500, 2000], intensities: [1, 255]);

    var msg = {'data': 'b'};
    await manualControl.publish(msg);
    // print('cmd published');

    // print('done publihsed2');
    // var msg = {'data': 'turn reverse'};
    // await reverse.publish(msg);
    // print('done publihsed reverse topic');
  }

  void backwardRelease_func() async {
    //change code to continously press button

    var msg = {'data': 'z'};
    await manualControl.publish(msg);
    // print('cmd published');
    // print('done publihsed forward topic');
  }

  void right_func() async {
    setState(() {
      forwardState = false;
      reverseState = false;
      rightState = true;
      leftState = false;
      movingState = true;
    });
    Vibration.vibrate(pattern: [500, 1000, 500, 2000], intensities: [1, 255]);
    var msg = {'data': 'r'};
    await manualControl.publish(msg);
    // print('cmd published');

    // var msg = {'data': 'turn right'};
    // await right.publish(msg);
    // print('done publihsed right topic');
  }

  void rightRelease_func() async {
    //change code to continously press button

    var msg = {'data': 'z'};
    await manualControl.publish(msg);
    // print('cmd published');
    // print('done publihsed forward topic');
  }

  void left_func() async {
    setState(() {
      forwardState = false;
      reverseState = false;
      rightState = false;
      leftState = true;
      movingState = true;
    });
    Vibration.vibrate(pattern: [500, 1000, 500, 2000], intensities: [1, 255]);
    var msg = {'data': 'l'};
    await manualControl.publish(msg);
    // print('cmd published');

    // var msg = {'data': 'turn left'};
    // await left.publish(msg);
    // print('done publihsed left topic');
  }

  void leftRelease_func() async {
    //change code to continously press button

    var msg = {'data': 'z'};
    await manualControl.publish(msg);
    // print('cmd published');
    // print('done publihsed forward topic');
  }

  void stop_func() async {
    setState(() {
      forwardState = false;
      reverseState = false;
      rightState = false;
      leftState = false;
      movingState = false;
    });
    Vibration.vibrate(duration: 1000);
    var msg = {'data': 'z'};
    await manualControl.publish(msg);

    // var msg = {'data': 'stop '};
    // await stop.publish(msg);
    // print('done publihsed stop topic');
  }

  void destroyConnection() async {
    //await chatter.unsubscribe(); //forward unadvertise?

    await manualControl.unadvertise();

    await ros.close();
    setState(() {});
  }

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          StreamBuilder<Object>(
            stream: ros.statusStream,
            builder: (context, snapshot) {
              return Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                      Color.fromARGB(255, 203, 43, 147),
                      Color.fromARGB(255, 149, 70, 196),
                      Color.fromARGB(255, 94, 97, 244),
                    ])),
                child: Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    title: Text("Manual Control"),
                    centerTitle: true,
                    automaticallyImplyLeading: false,
                  ),
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textBaseline: TextBaseline.alphabetic,
                    children: <Widget>[
                      //newly added
                      Text('Take Your Control', style: TextStyle(fontSize: 25)),
                      Padding(
                        padding: EdgeInsets.only(bottom: 20),
                      ),
                      ActionChip(
                        label: Text(snapshot.data == Status.connected
                            ? 'DISCONNECT'
                            : 'CONNECT'),
                        backgroundColor: snapshot.data == Status.connected
                            ? Colors.green[300]
                            : Colors.grey[300],
                        onPressed: () {
                          //print(snapshot.data);
                          if (snapshot.data != Status.connected) {
                            this.initConnection();
                          } else {
                            this.destroyConnection();
                          }
                        },
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildControlButton(
                              icon: Icons.arrow_upward,
                              pressed: forwardState,
                              onPressed: () {
                                forward_func();
                                // Send command to robot to move forward
                              },
                              onReleased: () {
                                forwardRelease_func();
                                setState(() {
                                  forwardState = false;
                                });
                              }),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildControlButton(
                            icon: Icons.arrow_back,
                            pressed: leftState,
                            onPressed: () {
                              //print('done publihsed');
                              left_func();
                              // Send command to robot to turn left
                            },
                            onReleased: () {
                              leftRelease_func();
                              setState(() {
                                leftState = false;
                              });
                            },
                          ),
                          // _buildControlButton(
                          //   icon: Icons.stop,
                          //   onPressed: () {
                          //     stop_func();
                          //     // Send command to robot to stop
                          //   },
                          //   onReleased: () {
                          //     stop_func();
                          //     setState(() {
                          //       rightState = false;
                          //     });
                          //     //print(forwardState);
                          //   },
                          // ),
                          //space between right and left arrows
                          SizedBox(
                            width: 70,
                          ),
                          _buildControlButton(
                            icon: Icons.arrow_forward,
                            pressed: rightState,
                            onPressed: () {
                              right_func();
                              // Send command to robot to turn right
                            },
                            onReleased: () {
                              rightRelease_func();
                              setState(() {
                                rightState = false;
                              });
                              //print(forwardState);
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _buildControlButton(
                              icon: Icons.arrow_downward,
                              pressed: reverseState,
                              onPressed: () {
                                backward_func();
                                // Send command to robot to move in reverse
                              },
                              onReleased: () {
                                backwardRelease_func();
                                setState(() {
                                  reverseState = false;
                                });
                                //print(forwardState);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          controller.isEnd.value ? EndNotify() : Container(),
        ],
      );
    });
  }

  Widget _buildControlButton(
      {IconData? icon,
      Function? onPressed,
      Function? onReleased,
      bool pressed = false}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onLongPressStart: (_) {
          onPressed!();
        },
        onLongPressEnd: (_) {
          onReleased!();
        },
        child: Container(
          decoration: BoxDecoration(
              color: pressed ? Color.fromARGB(255, 2, 77, 5) : Colors.green,

              //shadowColor: Colors.greenAccent,

              borderRadius: BorderRadius.circular(32.0)),

          //////// HERE

          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
