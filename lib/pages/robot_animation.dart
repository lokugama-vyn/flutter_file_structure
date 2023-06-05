import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';

class RobotAnimation extends StatelessWidget {
  Controller controller = Get.find();

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
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 1),
                        color: Color.fromRGBO(25, 113, 113, 1),
                      ),
                    ),
                    Obx(() {
                      return index ==
                              (controller.currentRow.value *
                                      controller.verticle.value) +
                                  controller.currentColumn.value
                          ? CircleAvatar(
                              backgroundColor:
                                  Color.fromARGB(255, 227, 209, 48),
                              child: FittedBox(
                                  child: Text(
                                "Cleaning",
                                style: TextStyle(color: Colors.black),
                              )),
                            )
                          : Container();
                    }),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
