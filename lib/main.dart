import 'package:flutter/material.dart';
import 'Screens/HomePage.dart';
import 'Screens/LoginPage.dart';

void main() => runApp(MyApp());

/*
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AmrAhmedProjectDemo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }

*/

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

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child: Container(
          width: 400,
          height: 450,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Material(
              child: Image.asset('assets/image/SeecuredLogo.png',width: 300, height: 100,)
              ),
              LoginPage(
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  'Username'),
              LoginPage(
                  Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  'Password'),
              Container(
                  width: 150,
                  height: 50,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    color: Colors.indigo,
                    textColor: Colors.white,
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 23.0,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    ));
  }
}
