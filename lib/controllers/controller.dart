import 'package:get/get.dart';
import 'package:roslibdart/roslibdart.dart';

class Controller extends GetxController {
  var verticle = 0.obs;
  var horizontal = 0.obs;
  var currentColumn = 3.obs;
  var currentRow = 0.obs;
  var ros = Ros(url: 'wss://solarpanelcleaningrobot.pagekite.me/').obs;
  var newRow; //TOPIC to handle row and column number
  var newRowDetails;

  void rosConnect() {
    ros.value.connect();
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
}
