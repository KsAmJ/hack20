import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:hack20/widgets/audio_button.dart';

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            Image(
              image: Svg(
                'assets/images/cd.svg',
                width: (screenSize.width * 0.8).floor(),
                height: (screenSize.width * 0.8).floor(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AudioButton(
                  icon: Icons.play_arrow,
                  handler: () {},
                ),
                SizedBox(
                  width: screenSize.width * 0.04,
                ),
                AudioButton(
                  icon: Icons.pause,
                  handler: () {},
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(right: 15, left: 15),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFFE6C8A3),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Text(
                        'Music Name',
                        textScaleFactor: 1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
