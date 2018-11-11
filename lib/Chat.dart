import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {

  TextEditingController textEditingController = new TextEditingController();
  ScrollController controller;

  int slength = 15;


  @override
  void initState() {
    controller = new ScrollController()..addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() {
    print(controller.position.extentAfter);
    if (controller.position.extentAfter < 15) {
      setState(() {
        slength+=15;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding :false,
      body: new Container(
        padding:new EdgeInsets.only(left:10.0,right:5.0,top: 10.0,bottom: 10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            new Expanded(
                child: _showMsg(),
            ),
            new Row(
              children: <Widget>[
                new Flexible(
                    child: new TextField(
                      decoration: new InputDecoration(hintText:"Enter your response."),
                      controller: textEditingController,
                      onSubmitted: _submit,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                    )
                ),
                new FlatButton(
                    onPressed:(){_submit(textEditingController.text);},
                    child: new Icon(Icons.send,color: Colors.green,))
              ],
            )
          ],
        ),
      ),
    );
  }


  Widget _showMsg(){

    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Chats').orderBy("time",descending: true).limit(slength).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        print(snapshot.toString());
        if (!snapshot.hasData) return new Text('Loading...');
        return new ListView.builder(
          controller: controller,
          reverse: true,
          itemCount: snapshot.data.documents.length,
          itemBuilder:(context,index) => buildItem(index, snapshot.data.documents[index]),
        );
      },
    );

  }

  void _submit(String text){

      textEditingController.clear();


      var documentReference = Firestore.instance
          .collection('Chats')
          .document();

      Firestore.instance.runTransaction((transaction) async {
        await transaction.set(
          documentReference,
          {
            'time': DateTime
                .now()
                .millisecondsSinceEpoch
                .toString(),
            'message': text,
            'name': "Dash"
          },
        );
      });

  }

  Widget buildItem(int index, DocumentSnapshot document) {

    return document["name"] == "Dash" ? new Card(
      color: Colors.red,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          new Text(document["name"],style: new TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          new Text(""),
          new Text(document["message"]),
          new Text("")
        ],
      ),
    ) :
    new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(" "+document["name"],style: new TextStyle(fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),),
          new Text(""),
          new Text(" "+document["message"]),
          new Text("")
        ],
      ),
    );


  }


}
