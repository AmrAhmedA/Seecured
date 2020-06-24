import 'package:flutter/material.dart';
import 'package:seecuredvoting/Screens/HomePage.dart';
import 'Screens/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AmrAhmedGraduation ProjectDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

double wp(double width, BuildContext context) { //Global function for setting the width accordingly to the dimensions of the media
  return MediaQuery.of(context).size.width * width / 100;
}

double hp(double height, BuildContext context) { //Global function for setting the height accordingly to the dimensions of the media
  return MediaQuery.of(context).size.height * height / 100;
}
