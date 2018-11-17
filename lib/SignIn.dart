import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Splash.dart';

void main(){

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
      appBar: new AppBar(title: new Text("App"),),
      body: Container(
        child: new Center(
          child: new FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if(snapshot.hasData)
                  return new Text("Something"+snapshot.data.toString());
                else
                  return fields();
              }
              else {
                return new Text('Loading...');
              }
            },
          ),
        ),
      ),
    );

  }

  Widget fields(){

    return new Center(
      child: Column(
        children: <Widget>[
          new TextField(
            decoration: InputDecoration(hintText: "Phone :"),
            onChanged: (val){
              this.Phone = val;
            },
          ),
          new RaisedButton(onPressed: verify,child: new Text("Verify"),),
          new Divider(height: 50.0,),
          new TextField(
            decoration: InputDecoration(hintText: "OTP :"),
            controller: controller,
            onChanged: (val){
              this.Phone = val;
            },
          ),
          new RaisedButton(onPressed: setOTP,child: new Text("check"),),
        ],
      ),
    );

  }

  Future<void> verify() async {

    print("Phone:"+Phone);

    PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout = (String id){
      this.vId = id;
    };

    PhoneCodeSent codeSent = (String id,[int forceCodeResend]){
      this.vId = id;
    };

    PhoneVerificationCompleted phoneVerificationCompleted = (FirebaseUser user){
      print(user);
    };

    PhoneVerificationFailed phoneVerificationFailed = (Exception e){
      print(e);
    };


    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "+91"+Phone,
        timeout: Duration(seconds: 10),
        verificationCompleted: null,
        verificationFailed: null,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: autoRetrievalTimeout
    );
    

    
  }
  
  
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }





  void setOTP() {

    String otp = controller.text;

    setState(() {

      vId = otp;

    });

  }
}
