import 'package:flutter/material.dart';

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
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  final double _gridSize = 20;
  late int _gridRowCount = 4;
  late int _gridColumnCount = 5;
  int _currentRow = 0;
  int _currentColumn = 0;
  int _currentColumnUpdate = 0;
  double gridcellLenght = 0;

  bool forwarddirection = true;
  @override
  void initState() {
    _gridRowCount = int.parse(widget.horizontal);
    _gridColumnCount = int.parse(widget.vertical);
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    _animation = Tween<Offset>(
      begin: Offset(_currentColumn.toDouble(), _currentRow.toDouble()),
      end: Offset(_currentColumn.toDouble(), _currentRow.toDouble()),
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void method() {
    setState(() {
      if (forwarddirection) {
        gridcellLenght = gridcellLenght +
            ((MediaQuery.of(context).size.width - 50) / _gridColumnCount) / 10;
        _currentColumnUpdate = _currentColumnUpdate + 1;

        if (_currentColumnUpdate == _gridColumnCount) {
          setState(() {
            _currentRow++;
            forwarddirection = !forwarddirection;
            _currentColumnUpdate = -1;
          });

          //print(_currentColumnUpdate.toString() + " " + _currentRow.toString());

        } else {
          _animation = Tween<Offset>(
            begin:
                Offset(_currentColumnUpdate.toDouble(), _currentRow.toDouble()),
            end: Offset(gridcellLenght, 0),
          ).animate(_animationController);
        }
        _animationController.forward();
        setState(() {});
      } else {
        gridcellLenght = gridcellLenght -
            ((MediaQuery.of(context).size.width - 50) / _gridColumnCount) / 10;
        _currentColumnUpdate = _currentColumnUpdate + 1;

        if (_currentColumnUpdate == _gridColumnCount) {
          setState(() {
            _currentRow++;
            forwarddirection = !forwarddirection;
            _currentColumnUpdate = -1;
          });

          //print(_currentColumnUpdate.toString() + " " + _currentRow.toString());

        } else {
          _animation = Tween<Offset>(
            begin:
                Offset(_currentColumnUpdate.toDouble(), _currentRow.toDouble()),
            end: Offset(gridcellLenght, 0),
          ).animate(_animationController);
        }
        _animationController.forward();
        setState(() {});
      }
    });
    //print(gridcellLenght);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(25),
            child: SingleChildScrollView(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _gridRowCount * _gridColumnCount,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridColumnCount,
                ),
                itemBuilder: (context, index) {
                  final rowIndex = (index / _gridColumnCount).floor();
                  final colIndex = index % _gridColumnCount;

                  return Container(
                    width: _gridSize,
                    height: _gridSize,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                    ),
                    child: Stack(
                      children: [
                        if (rowIndex == _currentRow &&
                            colIndex == _currentColumn)
                          SlideTransition(
                            position: _animation,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
            ),
            onPressed: method,
            child: Text(
              "Process Started",
            ),
          ),
        ],
      ),
    );
  }
}
