import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seecuredvoting/main.dart';
import 'UserMainDrawer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Seecured Election E-voting'),
        centerTitle: true,
        backgroundColor: Colors.indigo.withOpacity(0.8),
      ),
//      body: Image.asset("assets/image/candidate.jpg"),
      body: Column(
        children: <Widget>[
          SizedBox(height: hp(8, context)),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildCandidate(
                  "assets/image/candidate1.jpg",
                  "Candidate 1",
                  () async {
                    if (await showPopup("omar"))
                      print("Voted for omar");
                    else
                      print("Selection Canceled");
                  },
                ),
                buildCandidate(
                  "assets/image/candidate.jpg",
                  "Candidate 2",
                  () async {
                    if (await showPopup("Amr"))
                      print("Voted for Amr");
                    else
                      print("Selection Canceled");
                  },
                ),
              ],
            ),
          ),
          Container(
            height: hp(10, context),
            color: Colors.transparent,
          ),
          Image.asset(
            "assets/image/BUELOGO.png",
            scale: 1,
            fit: BoxFit.cover,
          ),
          SizedBox(height: hp(4, context)),
        ],
      ),
      drawer: MainDrawer(),
    );
  }

  Future<bool> showPopup(String candidate) async {
    bool answer = false;
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are You Sure?"),
            content: Text("Do you want to vote for $candidate"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  answer = true;
                },
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                  answer = false;
                },
                child: Text("No"),
              ),
            ],
          );
        });
    return answer;
  }

  Widget buildCandidate(String image, String name, Function onPressed) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.red, width: 8)),
              child: CircleAvatar(
                backgroundImage: AssetImage(image),
                radius: 75,
              ),
            ),
            SizedBox(height: hp(2, context)),
            RaisedButton(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: wp(2, context), vertical: hp(1.5, context)),
                child: Text(name,
                    style: TextStyle(color: Colors.white, fontSize: 17)),
              ),
              onPressed: onPressed,
              color: Colors.red,
              elevation: 8,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
//class _Counter extends State<HomePage> {
//  int _totalVoteCounter = 0;
//
//  void _IncrementCounter() {
//    setState(() {
//      _totalVoteCounter++;
//    });
//  }
//}

//RaisedButton(
//shape: RoundedRectangleBorder(
//borderRadius: BorderRadius.all(Radius.circular(10.0))),
//onPressed: () {
//Navigator.pop(context);
//},
//color: Colors.indigo,
//textColor: Colors.white,
//child: Text(
//'Back',
//style: TextStyle(
//fontSize: 20.0,
//),
//),
//)
