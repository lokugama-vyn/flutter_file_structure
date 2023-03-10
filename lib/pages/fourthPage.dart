import 'dart:math';
import 'package:flutter/material.dart';
import 'package:roslibdart/roslibdart.dart';

class fourthPage extends StatefulWidget {
  @override
  _fourthPageState createState() => _fourthPageState();
}

class _fourthPageState extends State<fourthPage> {
  late Ros ros;
  late Topic forward;
  late Topic reverse;
  late Topic stop;
  late Topic right;
  late Topic left;
  @override
  void initState() {
    ros = Ros(url: 'ws://10.10.22.249:9090');
    forward = Topic(
        ros: ros,
        name: '/topic',
        type: "std_msgs/Float64",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    right = Topic(
        ros: ros,
        name: '/topic',
        type: "std_msgs/Float64",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    reverse = Topic(
        ros: ros,
        name: '/topic',
        type: "std_msgs/Float64",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    left = Topic(
        ros: ros,
        name: '/topic',
        type: "std_msgs/Float64",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    stop = Topic(
      ros: ros,
      name: '/topic',
      type: "std_msgs/Float64",
      reconnectOnClose: true,
      queueSize: 10,
      queueLength: 10,
    );

    super.initState();
  }

  void initConnection() async {
    ros.connect();
    //await forward.subscribe(); //advertise?
    await forward.advertise();
    await right.advertise();
    await left.advertise();
    await reverse.advertise();
    await stop.advertise();
    setState(() {});
  }

  void forward_func() async {
    var msg = {'data': 'hello'};
    await forward.publish(msg);
    print('done publihsed');
  }

  void reverse_func() async {
    var linear = {'x': 0.5, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0.5};
    var twist = {'linear': linear, 'angular': angular};
    await reverse.publish(twist);
    print('cmd published');
  }

  void right_func() async {
    var linear = {'x': 0.5, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0.5};
    var twist = {'linear': linear, 'angular': angular};
    await reverse.publish(twist);
    print('cmd published');
  }

  void left_func() async {
    var linear = {'x': 0.5, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0.5};
    var twist = {'linear': linear, 'angular': angular};
    await reverse.publish(twist);
    print('cmd published');
  }

  void stop_func() async {
    var linear = {'x': 0.5, 'y': 0.0, 'z': 0.0};
    var angular = {'x': 0.0, 'y': 0.0, 'z': 0.5};
    var twist = {'linear': linear, 'angular': angular};
    await reverse.publish(twist);
    print('cmd published');
  }

  void destroyConnection() async {
    //await chatter.unsubscribe(); //forward unadvertise?
    await stop.unadvertise();
    await right.unadvertise();
    await left.unadvertise();
    await forward.unadvertise();
    await reverse.unadvertise();
    await ros.close();
    setState(() {});
  }

  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
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
                      onPressed: () {
                        forward_func();
                        // Send command to robot to move forward
                      },
                    ),
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
                      onPressed: () {
                        left_func();
                        // Send command to robot to turn left
                      },
                    ),
                    _buildControlButton(
                      icon: Icons.stop,
                      onPressed: () {
                        stop_func();
                        // Send command to robot to stop
                      },
                    ),
                    _buildControlButton(
                      icon: Icons.arrow_forward,
                      onPressed: () {
                        right_func();
                        // Send command to robot to turn right
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
                      onPressed: () {
                        reverse_func();
                        // Send command to robot to move in reverse
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildControlButton({IconData? icon, Function? onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.green,
          onPrimary: Colors.white,
          shadowColor: Colors.greenAccent,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
          minimumSize: Size(80, 80),
          //////// HERE
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
        onPressed: (() {}),
      ),
    );
  }
}
