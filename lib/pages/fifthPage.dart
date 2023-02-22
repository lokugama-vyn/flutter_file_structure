import 'package:flutter/material.dart';

import 'package:flutter_file_structure/pages/secondPage.dart';
import 'package:flutter_file_structure/pages/signin_screen.dart';

class fifthPage extends StatelessWidget {
  @override
  // TODO: implement widget
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color.fromARGB(255, 203, 43, 147),
            Color.fromARGB(255, 149, 70, 196),
            Color.fromARGB(255, 94, 97, 244),
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Container(
            width: 300,
            height: 300,
            padding: const EdgeInsets.only(top: 25),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: new Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Container(
                      child: Text('Are you sure, you want to Logout?',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                          textAlign: TextAlign.center),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(100, 40),
                        ),
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => SignInScreen(),
                            ),
                          );
                        },
                        child: Text('Yes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.center),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 25),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(206, 148, 211, 46),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0)),
                          minimumSize: Size(100, 40),
                        ),
                        onPressed: (() {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => SecondPage(
                                title: 'Solar Panel Cleaning Robot',
                              ),
                            ),
                          );
                        }),
                        child: Text('Cancel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                            textAlign: TextAlign.center),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Color.fromARGB(255, 94, 182, 214),
                Color.fromARGB(255, 180, 225, 211),
                Color.fromARGB(255, 184, 208, 209)
              ]),
              border: Border.all(
                width: 2,
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(25),
            ),
          ),
        ),
      ),
    );
  }
}
