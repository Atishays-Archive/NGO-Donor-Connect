import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngo_donor_connect/Donor_Home.dart';
import 'package:ngo_donor_connect/NGO_Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignUp.dart';

class MySignIn extends StatefulWidget {
  MySignIn({Key key}) : super(key: key);

  @override
  _MySignInState createState() => new _MySignInState();
}

class _MySignInState extends State<MySignIn> {
  bool th1 = true;
  final _id = TextEditingController();
  final _pass = TextEditingController();
  var _abc = "";

  Future<void> checkCurrent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getStringList("Data") == null) {
      setState(() {
        _abc = "";
      });
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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyNGOh()),
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyDonorH()),
            );
          }
        });
      });
    }
  }

  Future<void> saveD(String id, String pass) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList("Data", [id, pass]);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      checkCurrent();
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    _id.dispose();
    _pass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Sign In',
        ),
        automaticallyImplyLeading: false,
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Text(
              "$_abc",
              style: new TextStyle(
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              controller: _id,
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
              decoration: new InputDecoration(
                prefixIcon: Icon(
                  Icons.email,
                  color: Colors.green,
                ),
                hintText: "Enter Your Id",
                labelText: "Email",
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
            Padding(padding: EdgeInsets.only(top: 5.0)),
            new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              obscureText: th1,
              controller: _pass,
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
              decoration: new InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      th1 = !th1;
                    });
                  },
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.green,
                ),
                hintText: "Enter Your Password",
                labelText: "Password",
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
            Padding(padding: EdgeInsets.only(top: 5.0)),
            new RaisedButton(
              key: null,
              onPressed: () {
                var aid = _id.text;
                var apass = _pass.text;
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(email: aid, password: apass)
                    .then((user) async {
                  FirebaseDatabase.instance
                      .reference()
                      .child("NGO")
                      .child(user.user.uid)
                      .once()
                      .then((value) async {
                    await saveD(aid, apass);
                    if (value.value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyNGOh()),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyDonorH()),
                      );
                    }
                  });
                }).catchError((err) {
                  setState(() {
                    _abc = err.message;
                  });
                });
              },
              child: new Text(
                "Log In",
                style: new TextStyle(
                    color: const Color(0xFFffffff),
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"),
              ),
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
            ),
            new RaisedButton(
              key: null,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Mysignup()),
                );
              },
              child: new Text(
                "Sign Up",
                style: new TextStyle(
                    color: const Color(0xFFffffff),
                    fontWeight: FontWeight.w200,
                    fontFamily: "Roboto"),
              ),
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
            )
          ]),
    );
  }
}
