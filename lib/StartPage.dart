import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ngo_donor_connect/Donor_Home.dart';
import 'package:ngo_donor_connect/NGO_Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

import 'SignIn.dart';

class MyStart extends StatefulWidget {
  MyStart({Key key}) : super(key: key);

  @override
  _MyStartState createState() => new _MyStartState();
}

class _MyStartState extends State<MyStart> {
  var change;

  Future<void> checkCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("Data") == null) {
      change = MySignIn();
    } else {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: prefs.getStringList("Data")[0],
              password: prefs.getStringList("Data")[1])
          .then((value) {
        FirebaseDatabase.instance
            .reference()
            .child("NGO")
            .child(FirebaseAuth.instance.currentUser.uid)
            .once()
            .then((value) {
          if (value.value != null) {
            change = MyNGOh();
          } else {
            change = MyDonorH();
          }
        }).catchError((err) {
          change = MySignIn();
        });
      }).catchError((err) {
        change = MySignIn();
      });
    }
  }

  var abx = 3;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkCurrent();
      var timer = new Timer.periodic(new Duration(seconds: 1), (time) {
        abx = abx - 1;
        setState(() {});
        if (abx < 1) {
          time.cancel();
          if(change == null){
            change = MySignIn();
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => change),
          );
        }
      });
    });

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              "Hello",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            ),
            Padding(padding: EdgeInsets.only(top: 70.0)),
            new Text(
              "Project by Atishaya Jain\nApp Development(Flutter)",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            ),
            Padding(padding: EdgeInsets.only(top: 70.0)),
            new Text(
              abx.toString() + "s",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            ),
          ]),
    );
  }
}
