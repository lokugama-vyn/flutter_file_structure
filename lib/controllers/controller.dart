import 'package:get/get.dart';
import 'package:roslibdart/roslibdart.dart';

class Controller extends GetxController {
  var verticle = 0.obs;
  var horizontal = 0.obs;
  var currentColumn = 3.obs;
  late Topic newRow; //TOPIC to handle row and column number
  var currentRow = 0.obs;
  var ros = Ros(url: 'wss://solarpanelcleaningrobot.pagekite.me/').obs;

  var newRowDetails = '';
  late Topic warning;
  var warningDetails = ''.obs;
  late Topic end;
  var isError = false.obs;
  var isEnd = false.obs;

  Future<void> rosConnect() async {
    print('printed');
    ros.value.connect();
    rowColumnListener();
    await newRow.subscribe(subscribeHandler1);
    await warning.subscribe(subscribeHandler2);
    await end.subscribe(subscribeHandler3);
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
    end = Topic(
        ros: ros.value,
        name: '/end',
        type: "std_msgs/String",
        reconnectOnClose: true,
        queueLength: 10,
        queueSize: 10);

    //await newRow.subscribe(subscribeHandler1);
    await newRow.subscribe(subscribeHandler1);
    await warning.subscribe(subscribeHandler2);
    await warning.subscribe(subscribeHandler3);
  }

  Future<void> subscribeHandler1(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    newRowDetails = msg['data'];

    print(newRowDetails);
    //print(msg['data']);
  }

  Future<void> subscribeHandler3(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    isEnd.value = true;
    //print(msg['data']);
  }

  Future<void> subscribeHandler2(Map<String, dynamic> msg) async {
    //msg = {'data': '12'};
    warningDetails = msg['data'];

    print(warningDetails);
    //print(msg['data']);
    isError.value = true;
  }
}
