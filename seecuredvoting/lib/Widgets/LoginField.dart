import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:seecuredvoting/main.dart';

class LoginField extends StatefulWidget {
  Icon fieldIcon;
  String hinText;
  bool isPassword;
  Function onSaved;

  LoginField(
      {@required this.fieldIcon,
      this.hinText,
      this.isPassword = false,
      @required this.onSaved});

  @override
  _LoginFieldState createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  bool isHidden = true;

  void _toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.transparent,
      width: wp(70, context),
      child: Material(
        elevation: 5.0,
        color: Colors.indigo,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: widget.fieldIcon,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0))),
                width: wp(50, context),
                height: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: widget.onSaved,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: widget.hinText,
                      fillColor: Colors.white,
                      filled: true,
                      suffixIcon: widget.isPassword
                          ? IconButton(
                              onPressed: _toggleVisibility,
                              icon: isHidden
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility))
                          : null,
                    ),
                    style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.black,
                    ),
                    obscureText: widget.isPassword && isHidden,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
