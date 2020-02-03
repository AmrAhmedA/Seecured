import 'package:flutter/material.dart';

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
                      fontSize: 22,
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
            leading: Icon(Icons.person, size: 40),
            title: Text(
              'Profile',
              style: TextStyle(fontSize: 25),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.settings, size: 40),
            title: Text(
              'Settings',
              style: TextStyle(fontSize: 25),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.help, size: 40),
            title: Text(
              'Help',
              style: TextStyle(fontSize: 25),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.arrow_back, size: 40),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 25),
            ),
            onTap: null,
          ),
          ListTile(
            leading: Icon(Icons.copyright, size: 40),
            title: Text(
              'About',
              style: TextStyle(fontSize: 25),
            ),
            onTap: null,
          ),
        ],
      ),
    );
  }
}
