import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

import 'main.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {

    return new SplashScreen(
      seconds: 5,
      navigateAfterSeconds: new MyApp() ,
      image: new Image.asset("images/launcher.png"),
      title: new Text(""),
      photoSize: 200.0,
      backgroundColor: Colors.black,
      loaderColor: Colors.green,
    );

  }
}