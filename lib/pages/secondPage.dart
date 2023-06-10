import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_file_structure/controllers/controller.dart';

import 'package:flutter_file_structure/pages/thirdPage.dart';
import 'package:flutter_file_structure/sidebar/sidebar_layout.dart';
import 'package:get/get.dart';
import 'package:roslibdart/roslibdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

const List<Widget> icons = <Widget>[
  Text('Dry Clean'),
  Text('Wet Clean'),
];

class SecondPage extends StatefulWidget {
  const SecondPage({super.key, required this.title});

  final String title;

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final List<bool> _selectedWeather = <bool>[false, true];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController hPanelController = TextEditingController();
  TextEditingController vPanelController = TextEditingController();
  String horizontalPanels = "";
  String verticalPanels = "";
  bool vertical = false;
  late Topic columns;
  late Topic rows;
  late Topic startRobot;
  late Ros ros;
  //ros commands
  Controller controller = Get.find();
  late Topic clean_type;
  //var msg3 = ;
  var msg3 = {'data': ''};
  var msg4 = {'data': ''};
  var msg5 = {'data': ''};
  @override
  void initState() {
    ros = Ros(url: 'wss://solarpanelcleaningrobot.pagekite.me/');
    clean_type = Topic(
        ros: ros,
        name: '/clean_type',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    columns = Topic(
        ros: ros,
        name: '/columns',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    rows = Topic(
        ros: ros,
        name: '/rows',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    startRobot = Topic(
        ros: ros,
        name: '/startRobot',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    initConnection();

    super.initState();
  }

  Future<void> initConnection() async {
    ros.connect();
    // //controller.rowColumnListener();
    // //controller.rosConnect;
    // await controller.newRow.subscribe(controller.subscribeHandler1);
    // await controller.warning.subscribe(controller.subscribeHandler2);
    await clean_type.advertise();
    await columns.advertise();
    await rows.advertise();
    await startRobot.advertise();

    //await startRobot.publish(controller.startRobotmsg);
    setState(() {});
    print('hi');
  }

//need to add ros.connect() and advertisng topics method like initconnection
  void _dryClean() async {
    var msg1 = {'data': 'd'};
    await clean_type.publish(msg1);
  }

  void _wetClean() async {
    var msg2 = {'data': 'w'};
    await clean_type.publish(msg2);
  }

  Future<void> _startTimer() async {
    controller.timer_start = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        controller.seconds_count++;
      });
    });
  }

  void destroyConnection() async {
    //await chatter.unsubscribe(); //forward unadvertise?
    //await powerOn.unadvertise();

    //await controller.ros.value.close();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    var text;
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
          title: Text("User Panel"),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 15),
          child: Center(
            //mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.center,
            child: Column(
              children: <Widget>[
                const SizedBox(height: 8),
                Text('Cleaning Method',
                    style: TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 8),
                ToggleButtons(
                    direction: vertical ? Axis.vertical : Axis.horizontal,
                    onPressed: (int index) {
                      setState(() {
                        // The button that is tapped is set to true, and the others to false.

                        for (int i = 0; i < _selectedWeather.length; i++) {
                          _selectedWeather[i] = i == index;
                        }
                        //publish topics
                        if (index == 0) {
                          // initConnection();
                          _dryClean();
                        } else if (index == 1) {
                          //initConnection();
                          _wetClean();
                        }
                        destroyConnection();
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    selectedBorderColor: Colors.red[700],
                    selectedColor: Colors.white,
                    fillColor: Colors.red[200],
                    color: Colors.red[400],
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 80.0,
                    ),
                    isSelected: _selectedWeather,
                    children: icons),
                TextFormField(
                  controller: hPanelController,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Number of panels in horizontal direction',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: vPanelController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Number of panels in vertical direction',
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0)),
                      minimumSize: Size(300, 40),
                    ),
                    onPressed: () async {
                      //print(_formKey.currentState!.validate());
                      //print(hPanelController.text);
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (hPanelController.text == '' ||
                          hPanelController.text == null) {
                        print('horizontal null');
                        return showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert!'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text(
                                        'Please input number of horizontal and vertical panels of your solar system'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK,Got it.'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else if (vPanelController.text == '' ||
                          vPanelController.text == null) {
                        print('vertical null');
                        return showDialog(
                          context: context,
                          barrierDismissible: false, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Alert!'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text(
                                        'Please input number of horizontal and vertical panels of your solar system'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('OK,Got it.'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        // Process data.
                        SharedPreferences.setMockInitialValues({});
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setInt('horizontalpanels',
                            int.parse(hPanelController.text));
                        await prefs.setInt(
                            'verticalpanels', int.parse(vPanelController.text));
                        Controller controller = Get.find();
                        controller.verticle.value =
                            int.parse(vPanelController.text);
                        controller.horizontal.value =
                            int.parse(hPanelController.text);
                        //check init connection
                        // await initConnection();

                        FocusScopeNode currentFocus = FocusScope.of(context);
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SideBarLayout(),
                          ),
                        );
                      }
                      msg3['data'] = vPanelController.text;
                      msg4['data'] = hPanelController.text;
                      msg5['data'] = '0';
                      //print(msg['type']);
                      await columns.publish(msg3);
                      await rows.publish(msg4);
                      await startRobot.publish(msg5);
                      _startTimer();
                    },
                    child: const Text('Start'),
                  ),
                ),
              ],
            ),
          ),
        ),

        // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
