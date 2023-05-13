import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_file_structure/controllers/controller.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class RobotAnimation extends StatefulWidget {
  const RobotAnimation({
    super.key,
    required this.vertical,
    required this.horizontal,
  });
  final String vertical;
  final String horizontal;

  @override
  _RobotAnimationState createState() => _RobotAnimationState();
}

class _RobotAnimationState extends State<RobotAnimation>
    with TickerProviderStateMixin {
  Controller controller = Get.find();

  bool forwarddirection = true;
  @override
  void initState() {
    controller.animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    controller.animation = Tween<Offset>(
      begin: Offset(controller.currentColumn.value.toDouble(),
          controller.currentRow.value.toDouble()),
      end: Offset(controller.currentColumn.value.toDouble(),
          controller.currentRow.value.toDouble()),
    ).animate(controller.animationController);
    callmethod();
    super.initState();
  }

  void callmethod() {
    controller.method(controller.deviceSize.value);
  }

  @override
  void dispose() {
    controller.animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Container(
              padding: EdgeInsets.all(25),
              child: SingleChildScrollView(
                child: Obx(
                  () => GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: controller.gridRowCount.value *
                        controller.gridColumnCount.value,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: controller.gridColumnCount.value,
                    ),
                    itemBuilder: (context, index) {
                      final rowIndex =
                          (index / controller.gridColumnCount.value).floor();
                      final colIndex = index % controller.gridColumnCount.value;

                      return Container(
                        width: controller.gridSize.value,
                        height: controller.gridSize.value,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                        ),
                        child: Stack(
                          children: [
                            if (rowIndex == controller.currentRow.value &&
                                colIndex == controller.currentColumn.value)
                              SlideTransition(
                                position: controller.animation,
                                child: Column(children: <Widget>[
                                  CircleAvatar(
                                    radius:
                                        5, // change the radius as per your requirement
                                    backgroundColor: Colors.red,
                                    // change the color as per your requirement
                                    // add child widget if needed
                                  )
                                ]),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     backgroundColor: Colors.purple,
          //   ),
          //   onPressed: method,
          //   child: Text(
          //     "Process Started",
          //   ),
          // ),
        ],
      ),
    );
  }
}
