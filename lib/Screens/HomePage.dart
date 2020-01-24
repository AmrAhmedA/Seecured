import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: Row(
          children: <Widget>[
            Image.asset(
              "assets/image/BUELOGO.png",
              scale: 2.3,
              fit: BoxFit.cover,
            ),
            Text(
              'SU ELECTIONS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
      ),
//      body: Image.asset("assets/image/candidate.jpg"),
      body: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.red.withOpacity(0.8), width: 8)),
                    child: CircleAvatar(
                      backgroundImage:
                          AssetImage("assets/image/candidate1.jpg"),
                      radius: 75,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.red.withOpacity(0.9),
                    ),
                    child: FlatButton(
                      child: Text("Candidate 1",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () async {
                        if (await showPopup("Amr"))
                          print("Voted for candidate 1");
                        else
                          print("Selection Canceled");
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Colors.red.withOpacity(0.8), width: 10)),
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/image/candidate.jpg"),
                      radius: 75,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.red.withOpacity(0.9),
                    ),
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: FlatButton(
                      child: Text(
                        "Candidate 2",
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (await showPopup("Amr"))
                          print("Voted for candidate 2");
                        else
                          print("Selection Canceled");
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: buildDrawer(),
    );
  }

  Widget buildDrawer() {
    return Drawer(
        child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountEmail: Text("Amr162697@bue.edu.eg"),
          accountName: Text("Amr Ahmed Gewaly"),
          currentAccountPicture: CircleAvatar(
            child: Image.asset("assets/image/BUELOGO.png"),
          ),
        ),
        Container(),
      ],
    ));
  }

  Future<bool> showPopup(String candidate) async {
    bool answer = false;
    await showDialog(
        context: context,
        child: AlertDialog(
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
        ));
    return answer;
  }
}
