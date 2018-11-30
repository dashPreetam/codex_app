import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(new MaterialApp(
    home: SignIn(),
  ));
}

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController controller = new TextEditingController();

  String code;
  String Phone = "";
  String Name = "";
  String vId;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: new Center(
          child: new FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder:
                (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData)
                  return MyApp();
                else
                  return fields();
              } else {
                return new Text('Loading...');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget fields() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Image(
          image: AssetImage("images/Wallpaper.jpg"),
          fit: BoxFit.cover,
          color: Colors.brown[900],
          colorBlendMode: BlendMode.darken,
        ),
        new Theme(
            data: new ThemeData(
              brightness: Brightness.dark,
            ),
            child: AspectRatio(
                aspectRatio: 100 / 100,
                child: new ListView(shrinkWrap: true, children: <Widget>[
                  Container(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, top: 50.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Image(image: AssetImage("images/launcher.png")),
                          new TextField(
                            decoration: InputDecoration(hintText: "Phone :"),
                            onChanged: (val) {
                              this.Phone = val;
                            },
                          ),
                          new TextField(
                            decoration: InputDecoration(hintText: "Name :"),
                            onChanged: (val) {
                              this.Name = val;
                            },
                          ),
                          new Container(
                            padding: EdgeInsets.only(top: 20.0),
                            child: RaisedButton(
                              splashColor: Colors.cyan,
                              onPressed: verify,
                              child: new Text("Verify"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ])))
      ],
    );
  }

  Future<void> verify() async {
    if (Phone != "" && Name != "") {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("UserName", Name);
      prefs.setString("UserPhone", Phone);

      AlertDialog alert = new AlertDialog(
          shape: RoundedRectangleBorder(),
          title: Text("Please wait while we verify and login."),
          content: CircularProgressIndicator());

      showDialog(context: context, builder: (BuildContext context) => alert);

      PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String id) {
        this.vId = id;
      };

      PhoneCodeSent codeSent = (String id, [int forceCodeResend]) {
        this.vId = id;
      };

      PhoneVerificationCompleted phoneVerificationCompleted =
          (FirebaseUser user) {
        Navigator.of(context).pushReplacement(
            new MaterialPageRoute(builder: (BuildContext context) => MyApp()));
      };

      PhoneVerificationFailed phoneVerificationFailed = (Exception e) {

        AlertDialog alert = new AlertDialog(
            shape: RoundedRectangleBorder(),
            title: Text("Verification Failed"),
            content: Text(e.toString())
        );

        showDialog(context: context, builder: (BuildContext context) => alert);
      };

      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: "+91" + Phone,
          timeout: Duration(seconds: 10),
          verificationCompleted: phoneVerificationCompleted,
          verificationFailed: null,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: autoRetrievalTimeout);
    } else {
      AlertDialog alert = new AlertDialog(
          shape: RoundedRectangleBorder(),
          title: Text("Following fields cannot be blank."),
          content: Text("Phone \nName")
      );

      showDialog(context: context, builder: (BuildContext context) => alert);
    }
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }
}
