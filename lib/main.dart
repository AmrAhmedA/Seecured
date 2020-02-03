import 'package:flutter/material.dart';
import 'Screens/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmrAhmedProjectDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Login(),
    );
  }
}

double wp(double width, BuildContext context) {
  return MediaQuery.of(context).size.width * width / 100;
}

double hp(double height, BuildContext context) {
  return MediaQuery.of(context).size.height * height / 100;
}
