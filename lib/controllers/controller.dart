import 'package:get/get.dart';
import 'package:roslibdart/roslibdart.dart';
import 'package:vibration/vibration.dart';

class Controller extends GetxController {
  var verticle = 0.obs;
  var horizontal = 0.obs;
  var currentColumn = 0.obs;
  late Topic newRow; //TOPIC to handle row and column number
  var currentRow = 0.obs;
  var ros = Ros(url: 'wss://solarpanelcleaningrobot.pagekite.me/').obs;

  var newRowDetails = '';
  late Topic warning;
  var warningDetails = ''.obs;
  late Topic cleaning_state;
  var isError = false.obs;
  var isEnd = false.obs;
  String numbersString = '';
  var isEndvalue = false.obs;

  Future<void> rosConnect() async {
    print('printed');
    ros.value.connect();
    rowColumnListener();
    await newRow.subscribe(subscribeHandler1);
    await warning.subscribe(subscribeHandler2);
    await cleaning_state.subscribe(subscribeHandler3);
    print("connected");
  }

  // void rosConnect2() async {
  //   print('printed');
  //   ros.value.connect();

  //   print("connected");
  // }

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

    //await newRow.subscribe(subscribeHandler1);
    await newRow.subscribe(subscribeHandler1);
    await warning.subscribe(subscribeHandler2);
    await cleaning_state.subscribe(subscribeHandler3);
  }

  Future<void> subscribeHandler1(Map<String, dynamic> msg) async {
    //msg = {'data': '1,2'};
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
    //print(msg['data']);
  }

  Future<void> subscribeHandler2(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    warningDetails = msg['data'];

    print(warningDetails);
    //print(msg['data']);
    isError.value = true;
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
  }
}
