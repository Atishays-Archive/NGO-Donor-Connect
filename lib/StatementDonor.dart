import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ngo_donor_connect/Donor_Home.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainPage.dart';
import 'SignIn.dart';

class MyDStatement extends StatefulWidget {
  MyDStatement({Key key}) : super(key: key);

  @override
  _MyDStatementState createState() => new _MyDStatementState();
}

class _MyDStatementState extends State<MyDStatement> {
  var errtext = "Fetching Data";
  var user;
  List<dynamic> data = [];

  void abc() {
    FirebaseDatabase.instance
        .reference()
        .child("Donor")
        .child(user.uid)
        .once()
        .then((value) async {
      List<dynamic> myKeys = value.value.keys.toList();
      if (myKeys.contains("Donation")) {
        myKeys = value.value["Donation"].keys.toList();
        for (var i = 0; i < myKeys.length; i++) {
          var temp = {};
          temp["head"] = value.value["Donation"][myKeys[i]]["rname"].toString();
          temp["des"] = "Rs." +
              value.value["Donation"][myKeys[i]]["amount"].toString() +
              "\n" +
              value.value["Donation"][myKeys[i]]["date"].toString();
          data.add(temp);
        }
        errtext = "";
      } else {
        errtext = "You need to donate first.";
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
                  MaterialPageRoute(builder: (context) => MyDonorH()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              disabledColor: Colors.green,
              onPressed: () async {
                var mypos = await Geolocator.getCurrentPosition(
                    desiredAccuracy: LocationAccuracy.high);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyMainPage(
                            lat: mypos.latitude,
                            long: mypos.longitude,
                          )),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.request_page_sharp),
              onPressed: null,
              disabledColor: Colors.green,
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
