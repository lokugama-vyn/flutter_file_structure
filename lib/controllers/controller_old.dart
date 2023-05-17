// import 'package:flutter/animation.dart';
// import 'package:get/get.dart';

// class Controller_old extends GetxController {
//   var verticle = 0.obs;
//   var horizontal = 0.obs;
//   var gridSize = 20.0.obs;
//   var gridRowCount = 4.obs;
//   var gridColumnCount = 5.obs;
//   var currentRow = 0.obs;
//   var currentColumn = 0.obs;
//   var currentColumnUpdate = 0.obs;
//   var gridcellLenght = 0.0.obs;
//   late AnimationController animationController;
//   late Animation<Offset> animation;
//   var forwarddirection = true.obs;
//   var deviceSize = Size(0, 0).obs;

//   void initializeAnimation() {
//     gridRowCount.value = horizontal.value;
//     gridColumnCount.value = verticle.value;
//   }

//   Future<void> movingmethod(Size size) async {
//     if (forwarddirection.value) {
//       gridcellLenght.value = gridcellLenght.value +
//           ((size.width - 50) / gridColumnCount.value) / 10;
//       currentColumnUpdate.value = currentColumnUpdate.value + 1;

//       if (currentColumnUpdate.value == gridColumnCount.value) {
//         currentRow.value++;
//         forwarddirection.value = !forwarddirection.value;
//         currentColumnUpdate.value = -1;

//         //print(_currentColumnUpdate.toString() + " " + _currentRow.toString());

//       } else {
//         animation = Tween<Offset>(
//           begin: Offset(currentColumnUpdate.value.toDouble(),
//               currentRow.value.toDouble()),
//           end: Offset(gridcellLenght.value, 0),
//         ).animate(animationController);
//       }
//       await animationController.forward();
//     } else {
//       gridcellLenght.value = gridcellLenght.value -
//           ((size.width - 50) / gridColumnCount.value) / 10;
//       currentColumnUpdate.value = currentColumnUpdate.value + 1;

//       if (currentColumnUpdate.value == gridColumnCount.value) {
//         currentRow.value++;
//         forwarddirection.value = !forwarddirection.value;
//         currentColumnUpdate.value = -1;

//         //print(_currentColumnUpdate.toString() + " " + _currentRow.toString());

//       } else {
//         animation = Tween<Offset>(
//           begin: Offset(currentColumnUpdate.value.toDouble(),
//               currentRow.value.toDouble()),
//           end: Offset(gridcellLenght.value, 0),
//         ).animate(animationController);
//       }
//       await animationController.forward();
//     }
//   }

//   Future<void> method(Size size) async {
//     while (!((currentRow.value == gridRowCount.value - 1) &
//         (currentColumnUpdate.value == gridColumnCount.value - 1))) {
//       await movingmethod(size);
//       if (currentColumnUpdate.value == -1) {
//         await movingmethod(size);
//       }
//       print(currentRow.value.toString() +
//           " " +
//           currentColumnUpdate.value.toString());
//       await Future.delayed(Duration(seconds: 2));
//     }

//     //print(gridcellLenght);
//   }
// }
