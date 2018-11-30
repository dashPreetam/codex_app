import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Pinned extends StatefulWidget {
  @override
  _PinnedState createState() => _PinnedState();
}

class _PinnedState extends State<Pinned> {

  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Card(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(child: Text("Important",style: TextStyle(fontSize: 20.0)),color: Colors.red),
                Container(child: Text("Maybe",style: TextStyle(fontSize: 20.0)),color: Colors.green),
                Container(child: Text("Not so much",style: TextStyle(fontSize: 20.0)),color: Colors.blue),
              ],
            ),
          ),
          Expanded(child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Pinned').orderBy("Color" , descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            print(snapshot.toString());
            if (!snapshot.hasData) return new Text('Loading...');
            return new ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder:(context,index) => buildItem(index, snapshot.data.documents[index]),
            );
          },
        )
        )],
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document){

    String color = document["Color"];
    MaterialColor  colorValue;

    if(color=="Red")
      colorValue=Colors.red;
    else if(color=="Blue")
      colorValue=Colors.blue;
    else
      colorValue=Colors.green;

    return Container(padding: EdgeInsets.all(10.0), child: new Card(
      color: colorValue,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(document["Header"],style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Posted by : "),
              Text(document["Admin"],style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
              Text("   On "),
              Text(document["postDate"],style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)
            ],
          ),
          Text(" "),
          Text(document["Description"]),
          Text(" "),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Due Date :"),
              Text(document["dueDate"],style: TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    ),);

  }
}

