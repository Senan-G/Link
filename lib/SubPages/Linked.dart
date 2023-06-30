import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animated_background/animated_background.dart';

class Linked extends StatefulWidget {


  @override
  _LinkedState createState() => _LinkedState();
}

class _LinkedState extends State<Linked> with TickerProviderStateMixin{

  @override
  void initState() {
    super.initState();
    popTimer();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: AnimatedBackground(
        vsync: this,
        behaviour: BubblesBehaviour(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(FontAwesomeIcons.link, color: Colors.lightBlueAccent,),
              AnimatedTextKit(animatedTexts: [
                ScaleAnimatedText(
                  "LINKED!",
                  textStyle: TextStyle(
                    fontSize: 50.0,
                    fontFamily: 'Horizon',
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                  duration: const Duration(seconds: 4),
                )
              ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> popTimer() async {
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pop(context);
  }
}