import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class Admins extends StatefulWidget {
  @override
  _AdminsState createState() => _AdminsState();
}

class _AdminsState extends State<Admins> {



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      body: Container(
        child: new StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Admins').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print(snapshot.toString());
            if (!snapshot.hasData) return new Text('Loading...');
            return new ListView(
              children: snapshot.data.documents.map((DocumentSnapshot document) {
                return new FlatButton(
                    padding: new EdgeInsets.only(bottom: 20.0),
                    onPressed: () {
                      _showAlert(document['Name'], document['ImgPath'],
                          document['GitHub'], document['Contact']);
                    },
                    child: new Row(
                      children: <Widget>[
                        new Image.network(
                          document['ImgPath'],
                          height: 100.0,
                          width: 100.0,
                        ),
                        new Column(
                          children: <Widget>[
                            new Center(
                              child: new Text(
                                "    " + document['Name'],
                                style: new TextStyle(
                                    fontSize: 40.0, fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ));
              }).toList(),
            );
          },
        ),
      ),
    );
  }
  
  String id = "18ZZ";
  

  void _showAlert(String name, String path, String git, String cont) {


    AlertDialog dialog = new AlertDialog(
      title: new Center(
        child: new Text(
          name,
          style: new TextStyle(fontSize: 25.0),
        ),
      ),
      actions: <Widget>[
        new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              new Image.network(path, height: 350.0, width: 350.0),
              new Text(" "),
              new Text(" "),
              new Center(
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "GitHub :",
                      style: new TextStyle(
                        fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    new Text(git,style: new TextStyle(fontSize: 20.0,
                        fontStyle: FontStyle.italic,)),
                  ],
                ),
              ),
              new Text(" "),
              new Text(" "),
              new Center(
                child: new Row(
                  children: <Widget>[
                    new Text(
                      "Contact :",
                      style: new TextStyle(
                          fontSize: 20.0,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold),
                    ),
                    new Text(cont,style: new TextStyle(fontSize: 20.0,
                        fontStyle: FontStyle.italic,),),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );

    showDialog(context: context, child: dialog);
  }

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }
}