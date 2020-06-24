import 'package:flutter/material.dart';
import 'LoginPage.dart';
class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            color: Colors.indigo,
            child: Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 35,
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/image/1323.jpg"),
                          fit: BoxFit.fill,
                        )),
                  ),
                  Text(
                    'Amr Ahmed Gewaly',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Geek3mr@gmail.com',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person, size: 30),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 30),
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.help, size: 30),
            title: Text(
              'Help',
              style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.arrow_back, size: 30),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 18),
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            ),
          ),
          ListTile(
            leading: Icon(Icons.copyright, size: 30),
            title: Text(
              'About',
              style: TextStyle(fontSize: 18),
            ),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
