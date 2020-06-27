import 'package:flutter/material.dart';
import 'package:seecuredvoting/main.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: hp(6, context),
            ),
            Image.asset(
              "assets/image/BUE.png",
              scale: 1,
              width: 500,
              height: 250,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: hp(2, context), horizontal: hp(5, context)),
              child: Text(
                'This Project is Supervised by:',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gotham",
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: hp(0, context), horizontal: hp(5, context)),
              child: Text(
                'Dr. Abeer Hamdy - Dr. Mostafa Salama',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gotham",
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: hp(3, context),
            ),
            Column(
              children: <Widget>[
                Image.asset(
                  "assets/image/github_Logo.png",
                  width: 100,
                  height: 120,
                ),
                GestureDetector(
                    child: Text(
                      "AmrAhmedA/Seecured",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Gotham",
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    onTap: () =>
                        launch('https://github.com/AmrAhmedA/Seecured'))
              ,
              SizedBox(
                height: hp(2, context),
              )
              ,
                Image.asset("assets/image/Seecured.png",width: 200,)],
            )
          ],
        ),
      ),
    );
  }
}
