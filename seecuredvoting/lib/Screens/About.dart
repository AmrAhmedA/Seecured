import 'package:flutter/material.dart';
import 'package:seecuredvoting/main.dart';

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
                'Dr. Abeer Hamdy - Dr Mostafa Salama',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Gotham",
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,//Center Row contents horizontally,
                  crossAxisAlignment: CrossAxisAlignment.center,//Center Row contents vertically,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Image.asset(
                          "assets/image/github_Logo.png",
                          width: 100,
                          height: 250,
                        ),
                        Text("AmrAhmedA/Seecured", style: TextStyle(color: Colors.black, fontFamily: "Gotham", fontSize: 16, fontWeight: FontWeight.bold ),)
                      ],
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
