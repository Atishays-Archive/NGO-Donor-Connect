import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ngo_donor_connect/NGO_Home.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignIn.dart';

class MyNGOStatement extends StatefulWidget {
  MyNGOStatement({Key key}) : super(key: key);

  @override
  _MyNGOStatementState createState() => new _MyNGOStatementState();
}

class _MyNGOStatementState extends State<MyNGOStatement> {
  var errtext = "Fetching Data";
  var user;
  List<dynamic> data = [];

  void abc() {
    FirebaseDatabase.instance
        .reference()
        .child("NGO")
        .child(user.uid)
        .once()
        .then((value) async {
      List<dynamic> myKeys = value.value.keys.toList();
      if (myKeys.contains("Donation")) {
        myKeys = value.value["Donation"].keys.toList();
        for (var i = 0; i < myKeys.length; i++) {
          var temp = {};
          temp["head"] = value.value["Donation"][myKeys[i]]["sname"].toString();
          temp["des"] = "Rs." +
              value.value["Donation"][myKeys[i]]["amount"].toString() +
              "\n" +
              value.value["Donation"][myKeys[i]]["date"].toString();
          data.add(temp);
        }
        errtext = "";
      } else {
        errtext = "You don't have any donations";
      }
      setState(() {});
      setState(() {});
    }).catchError((err) {
      errtext = "Unexpected Error\n Try Again Later";
      setState(() {});
    });
  }

  Future<void> setData() async {
    user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user == null && prefs.getStringList("Data") == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MySignIn()),
      );
    } else if (user == null) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: prefs.getStringList("Data")[0],
              password: prefs.getStringList("Data")[1])
          .then((value) {
        user = value.user;
        abc();
      }).catchError((err) {
        errtext = "Unexpected Error\n Try Again Later";
        setState(() {});
      });
    } else {
      abc();
    }
  }

  @override
  void initState() {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Statement'),
        automaticallyImplyLeading: false,
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text(errtext),
            new Expanded(
                child: new ListView.separated(
              separatorBuilder: (context, index) => Divider(
                color: Colors.white,
                thickness: 5,
              ),
              itemCount: data.length,
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  title: Text(ReCase(data[index]["head"].toString()).titleCase),
                  subtitle:
                      Text(ReCase(data[index]["des"].toString()).titleCase),
                );
              },
            )),
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
                onPressed: null),
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
