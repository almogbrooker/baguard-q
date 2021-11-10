import 'dart:ui';

import 'package:flutter/material.dart';
import '../settings/settings_page.dart';

class AppBarQ extends AppBar {
  final BuildContext context;
  AppBarQ({required this.context})
      : super(
          automaticallyImplyLeading: true,
          backgroundColor: Colors.teal.withOpacity(0.7),
          title: Row(
            children: <Widget>[
              Image.asset(
                'assets/icon/AppBarLogo.png',
                fit: BoxFit.fill,
                width: 50,
                color: Colors.white,
              ),
              Text(
                'Baguard',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
              ),
            ],
          ),
        );
}

class DrawerQ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final name = 'Almog Brooker';
    final email = 'Almogg1000@gmail.com';
    return Drawer(
      child: Material(
        color: Colors.teal,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          children: [
            buildHeader(
              name: name,
              email: email,
            ),
            Divider(
              color: Colors.white70,
            ),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(
                icon: Icons.settings,
                text: 'Setting',
                onClicked: () => selectItem(context, 0)),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(icon: Icons.question_answer_sharp, text: 'FAQ'),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(icon: Icons.info_rounded, text: 'About Us'),
            const SizedBox(
              height: 16,
            ),
            buildMenuItem(icon: Icons.feedback, text: 'Feedback'),
            Divider(
              color: Colors.white70,
            ),
            Container(
                alignment: Alignment.center,
                child: Text(
                  'Version:',
                  style: TextStyle(color: Colors.black),
                )),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    final color = Colors.white;
    final hoverColor = Colors.white38;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(
        text,
        style: TextStyle(color: color, fontSize: 18),
      ),
      hoverColor: hoverColor,
      onTap: onClicked,
    );
  }

  void selectItem(BuildContext context, int index) {
    Navigator.of(context).pop();
    switch (index) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
        break;
    }
  }

  Widget buildHeader({
    required String name,
    required String email,
  }) =>
      InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  child: Icon(
                    Icons.person,
                    size: 30,
                  ),
                  backgroundColor: Colors.white,
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  name,
                  style: TextStyle(fontSize: 27, color: Colors.black54),
                ),
                Text(
                  email,
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ));
}

Widget buildMenuItem({
  required String text,
  required IconData icon,
  VoidCallback? onClicked,
}) {
  final color = Colors.white;
  final hoverColor = Colors.white38;
  return ListTile(
    leading: Icon(
      icon,
      color: color,
    ),
    title: Text(
      text,
      style: TextStyle(color: color),
    ),
    hoverColor: hoverColor,
    onTap: onClicked,
  );
}

void selectItem(BuildContext context, int index) {
  Navigator.of(context).pop();
  switch (index) {
    case 0:
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => SettingsPage(),
      ));
      break;
  }
}
