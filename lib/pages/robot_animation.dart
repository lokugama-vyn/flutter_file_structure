import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';

class RobotAnimation extends StatefulWidget {
  const RobotAnimation({super.key});

  @override
  _RobotAnimationState createState() => _RobotAnimationState();
}

class _RobotAnimationState extends State<RobotAnimation> {
  Controller controller = Get.find();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => GridView.builder(
              itemCount:
                  controller.horizontal.value * controller.verticle.value,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: controller.verticle.value),
              itemBuilder: (context, index) {
                if (index ==
                    (controller.currentRow.value * controller.verticle.value) +
                        controller.currentColumn.value) {
                  // This is the avatar
                  return CircleAvatar(
                    backgroundColor: Colors.green,
                    child: FittedBox(child: Text('cleaning')),
                  );
                } else {
                  // This is an empty grid cell
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 1),
                      color: Color.fromRGBO(25, 113, 113, 1),
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
