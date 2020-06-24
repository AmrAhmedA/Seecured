import 'dart:async';
import 'package:flutter/material.dart';
import 'package:seecuredvoting/Widgets/LoginField.dart';
import 'HomePage.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();

  String name, password;

  FocusNode nameFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

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
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Material(
                    child: Image.asset(
                  'assets/image/Seecured.png',
                  width: 300,
                  height: 100,
                )),
                LoginField(
                  fieldIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  hinText: 'Username',
                  onSaved: (text) {
                    name = text;
                  },
                  focusNode: nameFocusNode,
                  nextNode: passwordFocusNode,
                ),
                LoginField(
                  fieldIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  hinText: 'Password',
                  isPassword: true,
                  onSaved: (text) {
                    password = text;
                  },
                  focusNode: passwordFocusNode,
                ),
                Container(
                    width: 150,
                    height: 50,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      onPressed: () {
                        validate();
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
      ),
    ));
  }

  void validate() {
    showLoadingIndicator();
    Timer.periodic(Duration(milliseconds: 1500), (timer) {
      print(timer.tick);
      timer.cancel();
      formKey.currentState.save();
      Navigator.pop(context);
      if (name == "a" && password == "a") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        showPopup();
      }
    });
  }
  void showPopup() async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text("Invalid Credentials"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Close"),
              ),
            ],
          );
        });
  }
  void showLoadingIndicator() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(child: CircularProgressIndicator());
        });
  }
}
