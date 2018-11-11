import 'dart:async';
import 'Admins.dart';
import 'Chat.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool value = false;
  Image img;

  @override
  void initState() {
    getAllowsNotifications().then(setName);
    super.initState();
  }

  Future<bool> changeOnOff() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      value = !value;
      if (value)
        img = Image.asset("images/lightOn.png");
      else
        img = Image.asset("images/lightOff.png");
    });

    return prefs.setBool("Theme", value);
  }

  Future<bool> getAllowsNotifications() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool("Theme") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: value ? ThemeData.dark() : ThemeData.light(),
      home: DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: new AppBar(
            title: new Text("Codex"),
            actions: <Widget>[
              IconButton(
                  icon: img,
                  onPressed: () {
                    changeOnOff();
                  })
            ],
            bottom: TabBar(
              tabs: <Widget>[Tab(text: "Admins"), Tab(text: "Chat")],
            ),
          ),
                  body: TabBarView(children: [
                    Admins(),
                    Chat()
              ]),
          )),
    );
  }

  void setName(bool val) {
    setState(() {
      value = val;
      if (val)
        img = Image.asset("images/lightOn.png");
      else
        img = Image.asset("images/lightOff.png");
    });
  }
}
