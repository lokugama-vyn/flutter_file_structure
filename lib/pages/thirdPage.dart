import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_file_structure/controllers/controller.dart';

import 'package:flutter_file_structure/pages/robot_animation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:roslibdart/roslibdart.dart';

class thirdPage extends StatefulWidget {
  const thirdPage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<thirdPage> createState() => _thirdPageState();
}

class _thirdPageState extends State<thirdPage> {
  late Ros ros;
  late Topic battery_state;
  late Topic hours_cleaned;
  late Topic damage_detects;
  late Topic bat_state_request;
  late Topic hours_cleaned_request;
  late Topic damage_detects_request;
  var selectedTab = 1;
  String new1 = '';
  bool damage = true;
  String damage_details = '';
  String cleaning_hours = '';
  String battery_status = '';
  List<Choice> choices = <Choice>[
    Choice(title: 'Hours Taken :', icon: Icons.access_alarm, details: ''),
    Choice(
        title: 'Battery Level :',
        icon: Icons.battery_charging_full,
        details: ''),
    Choice(
        title: 'Damage Detection :',
        icon: Icons.cameraswitch_rounded,
        details: ''),
  ];
  @override
  void initState() {
    // TODO: implement initState
    ros = Ros(url: 'wss://solarpanelcleaningrobot.pagekite.me/');
    battery_state = Topic(
      ros: ros,
      name: '/battery_state',
      type: "std_msgs/String",
      reconnectOnClose: true,
      queueSize: 10,
      queueLength: 10,
    );
    hours_cleaned = Topic(
      ros: ros,
      name: '/hours_cleaned',
      type: "std_msgs/String",
      reconnectOnClose: true,
      queueSize: 10,
      queueLength: 10,
    );
    damage_detects = Topic(
      ros: ros,
      name: '/damage_detects',
      type: "std_msgs/String",
      reconnectOnClose: true,
      queueSize: 10,
      queueLength: 10,
    );
    bat_state_request = Topic(
        ros: ros,
        name: '/bat_state_request',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    hours_cleaned_request = Topic(
        ros: ros,
        name: '/hours_cleaned_request',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    damage_detects_request = Topic(
        ros: ros,
        name: '/damage_detects_request',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    super.initState();
    mymethod();
    //initConnection();
  }

  void initConnection() async {
    ros.connect();
    await bat_state_request.advertise();
    var msg = {'data': 'battery_state_requesting '};
    await bat_state_request.publish(msg);
    await hours_cleaned_request.advertise();
    var msg2 = {'data': 'hours_cleaned_requesting '};
    await hours_cleaned_request.publish(msg2);
    await damage_detects_request.advertise();
    var msg3 = {'data': 'damage_detects_requesting '};
    await damage_detects_request.publish(msg3);
    await damage_detects.subscribe(subscribeHandler1);
    await hours_cleaned.subscribe(subscribeHandler2);
    await battery_state.subscribe(subscribeHandler3);
    //await forward.subscribe(); //advertise?

    setState(() {});
  }

//store topics details in strings

  Future<void> subscribeHandler1(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    damage_details = msg['data'];
    choices[2] = Choice(
        title: 'Damage Detection :',
        icon: Icons.cameraswitch_rounded,
        details: damage_details);
    print(damage_details);
    //print(msg['data']);
    setState(() {});
  }

  Future<void> subscribeHandler2(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    cleaning_hours = msg['data'];
    choices[0] = Choice(
        title: 'Hours Taken :',
        icon: Icons.access_alarm,
        details: cleaning_hours);
    setState(() {});
  }

  Future<void> subscribeHandler3(Map<String, dynamic> msg) async {
    //msg = {'data': '15'};
    battery_status = msg['data'];
    choices[1] = Choice(
        title: 'Battery Level :',
        icon: Icons.battery_charging_full,
        details: battery_status);
    setState(() {});
  }

  //TOPIC HANDLING
  void destroyConnection() async {
    //await chatter.unsubscribe(); //forward unadvertise?
    await damage_detects.unsubscribe();
    await hours_cleaned.unsubscribe();
    await battery_state.unsubscribe();

    await ros.close();
    setState(() {});
  }

  int? verticle = null;
  int? horizontal = null;
  Future<void> mymethod() async {
    final prefs = await SharedPreferences.getInstance();
    Controller controller = Get.find();

    setState(() {
      verticle = controller.verticle.value;
      horizontal = controller.horizontal.value;
    });
    //print(vertical.toString() + " " + horizontal.toString());
  }

  @override
  void _cleaning() {
    //edited
    setState(() {
      selectedTab = 1;
    });
  }

  void _cleaning_finished() {
    setState(() {
      selectedTab = 2;
    });
  }

  void damagedetects() {
    setState(() {
      selectedTab = 2;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return StreamBuilder<Object>(
      stream: ros.statusStream,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Monitoring Panel"),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: Container(
            child: Column(
              children: <Widget>[
                Container(
                  color: Colors.deepOrange,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                        ),
                        onPressed: _cleaning,
                        child: Text(
                          "Cleaning",
                          style: TextStyle(
                              fontWeight: selectedTab == 1
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 20),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(206, 148, 211, 46),
                        ),
                        onPressed: _cleaning_finished,
                        child: Text(
                          "Cleaning Finished",
                          style: TextStyle(
                              fontWeight: selectedTab == 2
                                  ? FontWeight.bold
                                  : FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
                (verticle == null || horizontal == null)
                    ? Container()
                    : Container(
                        height: MediaQuery.of(context).size.height - 130,
                        child: LayoutBuilder(builder: (context, constraints) {
                          if (selectedTab == 1) {
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
                              child: RobotAnimation(
                                  currentRow: 2, currentColumn: 3),
                            );
                          } else {
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
                                body: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(right: 15),
                                      ),
                                      Expanded(
                                        // Added
                                        child: Container(
                                            child: Column(
                                          children: [
                                            ActionChip(
                                              label: Text(snapshot.data ==
                                                      Status.connected
                                                  ? 'DISCONNECT'
                                                  : 'CONNECT'),
                                              backgroundColor: snapshot.data ==
                                                      Status.connected
                                                  ? Colors.green[300]
                                                  : Colors.grey[300],
                                              onPressed: () async {
                                                if (snapshot.data !=
                                                    Status.connected) {
                                                  this.initConnection();
                                                } else {
                                                  this.destroyConnection();
                                                }
                                              },
                                            ),
                                            Expanded(
                                              child: GridView.count(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 4.0,
                                                mainAxisSpacing: 8.0,
                                                children: List.generate(
                                                    choices.length, (index) {
                                                  return Center(
                                                    child: SelectCard(
                                                        choice: choices[index]),
                                                  );
                                                }),
                                              ),

                                              // Added
                                            ),
                                          ],
                                        )),
                                      ),
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height -
                                              280,
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              top: 15, bottom: 10),
                                          child: damage
                                              ? Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/caution.jpg'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: AssetImage(
                                                          'assets/images/robot.jpg'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                      )
              ],
            ),
          ),
        );
      },
    );
  }
}

class Choice {
  const Choice(
      {required this.title, required this.icon, required this.details});
  final String title;
  final IconData icon;
  final String details;
}

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    var display1;

    //final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
        color: Colors.orange,
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(child: Icon(choice.icon, size: 50.0)),
                Text(choice.title + choice.details),
              ]),
        ));
  }
}
