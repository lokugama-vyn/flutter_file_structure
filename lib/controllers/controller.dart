import 'package:get/get.dart';
import 'package:roslibdart/roslibdart.dart';

class Controller extends GetxController {
  var verticle = 0.obs;
  var horizontal = 0.obs;
  var currentColumn = 3.obs;
  late Topic newRow; //TOPIC to handle row and column number
  var currentRow = 0.obs;
  var ros = Ros(url: 'wss://solarpanelcleaningrobot.pagekite.me/').obs;

  var newRowDetails;
  var warning;
  var warningDetails = ''.obs;
  var isError = false.obs;

  Future<void> rosConnect() async {
    ros.value.connect();
    //await newRow.subscribe(subscribeHandler1);
    print("connected");
  }

  Future<void> rowColumnListener() async {
    newRow = Topic(
        ros: ros.value,
        name: '/newRow',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    await newRow.subscribe(subscribeHandler1);
  }

  Future<void> subscribeHandler1(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    newRowDetails = msg['data'];

    print(newRowDetails);
    //print(msg['data']);
  }

  Future<void> warningFunc() async {
    warning = Topic(
        ros: ros.value,
        name: '/warning',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);
    await warning.subscribe(subscribeHandler2);
  }

  Future<void> subscribeHandler2(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    warningDetails = msg['data'];

    print(warningDetails);
    print(msg['data']);
    isError.value = true;
  }
}
