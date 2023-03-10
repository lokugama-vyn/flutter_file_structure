import 'package:flutter/material.dart';

import 'package:flutter_file_structure/pages/thirdPage.dart';
import 'package:flutter_file_structure/sidebar/sidebar_layout.dart';
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
  //ros commands
  late Ros ros;
  late Topic _drycleanMsg;
  late Topic _wetcleanMsg;
  void initState() async {
    ros = Ros(url: 'ws://10.10.22.249:9090');
    _drycleanMsg = Topic(
        ros: ros,
        name: '/topic',
        type: "std_msgs/bool",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    _wetcleanMsg = Topic(
        ros: ros,
        name: '/topic',
        type: "std_msgs/bool",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    ros.connect();

    await _drycleanMsg.advertise();
    await _wetcleanMsg.advertise();
    super.initState();
  }

  void _dryClean() async {
    bool _dryclean = true;
    await _drycleanMsg.publish(_dryclean);
  }

  void _wetClean() async {
    bool _wetclean = true;
    await _wetcleanMsg.publish(_wetclean);
  }

  void destroyConnection() async {
    //await chatter.unsubscribe(); //forward unadvertise?
    await _drycleanMsg.unadvertise();
    await _wetcleanMsg.unadvertise();

    await ros.close();
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
                          _dryClean();
                        } else if (index == 1) {
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
                      print(hPanelController.text);
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

                        FocusScopeNode currentFocus = FocusScope.of(context);
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => SideBarLayout(),
                          ),
                        );
                      }
                    },
                    child: const Text('Submit'),
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
