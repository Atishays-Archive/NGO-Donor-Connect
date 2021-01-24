import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Donor_Home.dart';
import 'NGO_Home.dart';
import 'SignIn.dart';

class Mysignup extends StatefulWidget {
  Mysignup({Key key}) : super(key: key);

  @override
  _MysignupState createState() => new _MysignupState();
}

class _MysignupState extends State<Mysignup> {
  bool th1 = true;
  bool th2 = true;
  String _abc = "";
  var radioItem = "NGO";
  final _id = TextEditingController();
  final _pass = TextEditingController();
  final _name = TextEditingController();
  final _rpass = TextEditingController();

  Future<void> checkCurrent() async {
    if (FirebaseAuth.instance.currentUser == null) {
      setState(() {
        _abc = "";
      });
    } else {
      FirebaseDatabase.instance
          .reference()
          .child("NGO")
          .child(FirebaseAuth.instance.currentUser.uid)
          .once()
          .then((value) {
        List<dynamic> myKeys = value.value.keys.toList();
        if (myKeys.length > 0) {
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
    // Clean up the controller when the widget is disposed.
    _id.dispose();
    _pass.dispose();
    _name.dispose();
    _rpass.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Sign Up'),
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
              controller: _name,
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
              decoration: new InputDecoration(
                hintText: "Enter Your Name",
                labelText: "Name",
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.green,
                ),
                helperText: "Username visible to Players",
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
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
              controller: _pass,
              obscureText: th1,
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
            new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
              controller: _rpass,
              obscureText: th2,
              decoration: new InputDecoration(
                suffixIcon: IconButton(
                  icon: Icon(Icons.remove_red_eye),
                  onPressed: () {
                    setState(() {
                      th2 = !th2;
                    });
                  },
                ),
                prefixIcon: Icon(
                  Icons.lock,
                  color: Colors.green,
                ),
                hintText: "Retype Your Password",
                labelText: "Retype Password",
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
            new Text(
              "Register As",
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  fontFamily: "Roboto"),
            ),
            new Row(
              children: [
                new Radio(
                  groupValue: radioItem,
                  value: "NGO",
                  onChanged: (val) {
                    setState(() {
                      radioItem = val;
                    });
                  },
                ),
                new Text("NGO")
              ],
            ),
            new Row(
              children: [
                new Radio(
                  groupValue: radioItem,
                  value: "Donor",
                  onChanged: (val) {
                    setState(() {
                      radioItem = val;
                    });
                  },
                ),
                new Text("Donor")
              ],
            ),
            new RaisedButton(
              key: null,
              onPressed: () async {
                if (_name.text == "" ||
                    _id.text == "" ||
                    _pass.text == "" ||
                    _rpass.text == "") {
                  setState(() {
                    _abc = "Any of feild is left Empty";
                  });
                } else if (_pass.text != _rpass.text) {
                  setState(() {
                    _abc = "Password & Retype Password don't match";
                  });
                } else {
                  setState(() {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _id.text, password: _pass.text)
                        .then((value) async => {
                              await saveD(_id.text, _pass.text),
                              FirebaseDatabase.instance
                                  .reference()
                                  .child(radioItem)
                                  .child(value.user.uid)
                                  .set({
                                "name": _name.text,
                                "id": _id.text
                              }).then((value) {
                                if (radioItem == "NGO") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyNGOh()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyDonorH()),
                                  );
                                }
                              })
                            })
                        .catchError((err) {
                      setState(() {
                        _abc = err.message;
                      });
                    });
                  });
                }
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
            ),
            new RaisedButton(
              key: null,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MySignIn()),
                );
              },
              child: new Text(
                "Sign In",
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
