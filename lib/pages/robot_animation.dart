import 'package:flutter/material.dart';

class RobotAnimation extends StatefulWidget {
  final int currentRow;
  final int currentColumn;

  RobotAnimation({required this.currentRow, required this.currentColumn});

  @override
  _RobotAnimationState createState() => _RobotAnimationState();
}

class _RobotAnimationState extends State<RobotAnimation> {
  late int currentRow;
  late int currentColumn;

  @override
  void initState() {
    super.initState();
    currentRow = widget.currentRow;
    currentColumn = widget.currentColumn;
  }

  void moveAvatar(int newRow, int newColumn) {
    setState(() {
      currentRow = newRow;
      currentColumn = newColumn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: GridView.builder(
            itemCount: 25,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5),
            itemBuilder: (context, index) {
              if (index == (currentRow * 5) + currentColumn) {
                // This is the avatar
                return GestureDetector(
                  onTap: () {
                    // Move the avatar to a new position when tapped
                    moveAvatar((index / 5).floor(), index % 5);
                  },
                  child: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text('cleaning'),
                  ),
                );
              } else {
                // This is an empty grid cell
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1.0,
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
