import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngo_donor_connect/NGO_Home.dart';
import 'package:ngo_donor_connect/SignIn.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'StatementNGO.dart';

class MyNGO_Set extends StatefulWidget {
  MyNGO_Set({Key key}) : super(key: key);

  @override
  _MyNGO_Set createState() => new _MyNGO_Set();
}

class _MyNGO_Set extends State<MyNGO_Set> {
  final _id = TextEditingController();

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  var err = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 50.0)),
            new Text(
              err,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                  color: Colors.red,
                  fontFamily: "Roboto"),
            ),
            new Text(
              "Description :",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            ),
            new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 2,
              controller: _id,
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
              decoration: new InputDecoration(
                hintText: "Description",
                labelText: "Description",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 4, color: Colors.green)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 4, color: Colors.red)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 4, color: Colors.white)),
              ),
            ),
            new RaisedButton(
              onPressed: () {
                print("hello");
              },
              child: new Text("Update Description"),
            ),
            Padding(padding: EdgeInsets.only(top: 20.0)),
            new Text(
              "Address :",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            ),
            new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.multiline,
              minLines: 2,
              maxLines: 2,
              controller: _id,
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
              decoration: new InputDecoration(
                hintText: "Address",
                labelText: "Address",
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 4, color: Colors.green)),
                errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 4, color: Colors.red)),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    borderSide: BorderSide(width: 4, color: Colors.white)),
              ),
            ),
            new RaisedButton(
              onPressed: () {
                print("hello");
              },
              child: new Text("Update Address"),
            ),
          ]),
      bottomNavigationBar: BottomAppBar(
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              disabledColor: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyNGOh()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.request_page_sharp),
              disabledColor: Colors.green,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyNGOStatement()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              disabledColor: Colors.green,
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                FirebaseAuth.instance.signOut().then((value) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MySignIn()),
                  );
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
