import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final onTap;

  const MenuItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(children: <Widget>[
          Icon(
            icon,
            color: Colors.cyan,
            size: 30,
          ),
          SizedBox(
            width: 30,
          ),
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w300, fontSize: 20, color: Colors.white),
          )
        ]),
      ),
    );
  }
}
