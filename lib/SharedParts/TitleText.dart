import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;

  const TitleText(@required this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 30,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
    );
  }
}

class TitleText2 extends StatelessWidget {
  final String text;

  const TitleText2(@required this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class subTitleText extends StatelessWidget {
  final String text;

  const subTitleText(@required this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w500
      ),
      textAlign: TextAlign.center,
    );
  }
}

class buttonText extends StatelessWidget {
  final String text;

  const buttonText(@required this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
      style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 15,
          color: Colors.white,
          fontWeight: FontWeight.w500
      ),
      textAlign: TextAlign.center,
    );
  }
}