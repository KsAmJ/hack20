import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AudioButton extends StatelessWidget {
  final IconData icon;
  final Function handler;
  const AudioButton({Key key, this.icon, this.handler}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return CupertinoButton(
      minSize: 1,
      padding: EdgeInsets.zero,
      child: Container(
        width: screenSize.width * 0.18,
        height: screenSize.width * 0.18,
        decoration: BoxDecoration(
          color: Color(0xFFF8DEBE),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 3),
              blurRadius: 6,
              color: Colors.black38,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.black,
          size: screenSize.width * 0.1,
        ),
      ),
      onPressed: () {
        handler();
      },
    );
  }
}
