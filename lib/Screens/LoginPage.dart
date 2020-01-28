import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'HomePage.dart';
import 'package:seecuredvoting/Screens/HomePage.dart';

class LoginPage extends StatelessWidget {
  Icon fieldIcon;
  String hinText;
  bool _isHidden = true;

  void _toggleVisibility(){
      _isHidden=!_isHidden;
  }
  LoginPage(this.fieldIcon, this.hinText);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: 250,
      child: Material(
        elevation: 5.0,
        color: Colors.indigo,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(padding: const EdgeInsets.all(12.0), child: fieldIcon),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0))),
              width: 200,
              height: 60,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hinText,
                    fillColor: Colors.white,
                    filled: true,
                    icon: hinText == 'Password' ? IconButton( onPressed: _toggleVisibility, icon: _isHidden? Icon(Icons.visibility_off):Icon(Icons.visibility_off) ) : null,
                  ),
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                  obscureText: hinText == 'Password' ? _isHidden : false,

                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
