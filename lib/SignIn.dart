import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'Splash.dart';

void main() {
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
  String Phone;
  String vId;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: new Center(
          child: new FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData)
                  return Splash();
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
    return new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new TextField(
            decoration: InputDecoration(hintText: "Phone :"),
            onChanged: (val) {
              this.Phone = val;
            },
          ),
          new RaisedButton(
            onPressed: verify,
            child: new Text("Verify"),
          ),
          new Divider(
            height: 50.0,
          ),
        ],
      ),
    );
  }

  Future<void> verify() async {
    AlertDialog alert = new AlertDialog(
        shape: RoundedRectangleBorder(),
        title: Text("Please wait while we verify and login."),
        content: CircularProgressIndicator(value: 1.0));

    showDialog(context: context, builder: (BuildContext context) => alert);

    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String id) {
      this.vId = id;
    };

    PhoneCodeSent codeSent = (String id, [int forceCodeResend]) {
      this.vId = id;
    };

    PhoneVerificationCompleted phoneVerificationCompleted =
        (FirebaseUser user) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Splash()),
      );
    };

    PhoneVerificationFailed phoneVerificationFailed = (Exception e) {
      print(e);
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91" + Phone,
        timeout: Duration(seconds: 10),
        verificationCompleted: phoneVerificationCompleted,
        verificationFailed: null,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout);
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }
}
