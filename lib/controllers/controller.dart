import 'dart:async';

import 'package:get/get.dart';
import 'package:roslibdart/roslibdart.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vibration/vibration.dart';
import 'package:timer_count_down/timer_count_down.dart';

class Controller extends GetxController {
  var verticle = 0.obs;
  var horizontal = 0.obs;
  var currentColumn = 0.obs;
  late Topic newRow; //TOPIC to handle row and column number
  var currentRow = 0.obs;
  var _isTimerRunning = false.obs;
  var seconds_count = 0.obs;
  late Timer timer_start;
  var ros = Ros(url: 'wss://solarpanelcleaningrobot.pagekite.me/').obs;

  var newRowDetails = ''.obs;
  late Topic warning;
  var warningDetails = ''.obs;
  late Topic cleaning_state;
  var isError = false.obs;
  var isEnd = false.obs;
  var numbersString = ''.obs;
  var isEndvalue = false.obs;
  var time_spend = ''.obs;
  var userWarning = ''.obs;
  var warningNumber = 0.obs;

  Future<void> rosConnect() async {
    print('printed');
    ros.value.connect();
    rowColumnListener();
    await newRow.subscribe(subscribeHandler1);
    await warning.subscribe(subscribeHandler2);
    await cleaning_state.subscribe(subscribeHandler3);
    print("connected");
  }

  void _stopTimer() {
    timer_start.cancel();
    int minutes = seconds_count.value ~/ 60;
    int remainingSeconds = seconds_count.value % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    time_spend.value = minutesStr + ':' + secondsStr;
    _isTimerRunning.value = false;
    seconds_count = 0.obs;
  }

  Future<void> rowColumnListener() async {
    newRow = Topic(
        ros: ros.value,
        name: '/newRow',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    warning = Topic(
        ros: ros.value,
        name: '/warning',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    cleaning_state = Topic(
        ros: ros.value,
        name: '/cleaning_state',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    await newRow.subscribe(subscribeHandler1);
    await warning.subscribe(subscribeHandler2);
    await cleaning_state.subscribe(subscribeHandler3);
  }

  Future<void> subscribeHandler1(Map<String, dynamic> msg) async {
    newRowDetails = msg['data'];
    List<String> numberList = newRowDetails.split(",");

    currentRow.value = int.parse(numberList[0]);
    currentColumn.value = int.parse(numberList[1]);
    print(currentRow.value);
    print(currentColumn.value);
  }

  Future<void> subscribeHandler3(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    isEnd.value = true;
    isEndvalue.value = true;
    Vibration.vibrate(
      pattern: [
        0,
        200,
        200,
        200,
        200,
        200
      ], // Wait 0ms, vibrate 200ms, wait 200ms, vibrate 200ms, and so on...
    );
    _stopTimer();
    //print(msg['data']);
  }

  Future<void> subscribeHandler2(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    print(msg['data']);
    // print(msg['data'].runtimeType);
    // warningDetails = msg['data'];

    //print(warningDetails);
    if (msg['data'] == '1') {
      isError.value = true;
      warningNumber.value = 1;
      userWarning.value = 'I2C Disabled. Cannot go beyond.';
    }
    if (msg['data'] == '2') {
      //isError.value = true;
      warningNumber.value = 2;
      userWarning.value = 'Edge detected. Cannot go forward.';
    }
    if (msg['data'] == '3') {
      //isError.value = true;
      warningNumber.value = 3;
      userWarning.value = 'Edge detected. Cannot go backward.';
    }
    if (msg['data'] == '4') {
      //isError.value = true;
      warningNumber.value = 4;
      userWarning.value = 'Edge detected. Cannot turn left.';
    }
    if (msg['data'] == '5') {
      //isError.value = true;
      warningNumber.value = 5;
      userWarning.value = 'Edge detected. Cannot turn right.';
    }
    if (msg['data'] == '0') {
      //isError.value = true;
      warningNumber.value = 0;
      //userWarning.value = 'Edge detected. Cannot go beyond.';
    }
    if (msg['data'] == '6') {
      isError.value = true;
      warningNumber.value = 6;
      userWarning.value = 'Abnormal tilt detected.Abort';
    }
    if (msg['data'] == '7') {
      isError.value = true;
      warningNumber.value = 7;
      userWarning.value = 'Cannot initialize IMU.';
    }

    //print(msg['data']);
  }
}
