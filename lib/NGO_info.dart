import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ngo_donor_connect/Donor_Home.dart';
import 'package:ngo_donor_connect/MainPage.dart';
import 'package:ngo_donor_connect/SignIn.dart';
import 'package:intl/intl.dart';
import 'package:ngo_donor_connect/StatementDonor.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyNGOI extends StatefulWidget {
  final String uid;

  MyNGOI({Key key, @required this.uid}) : super(key: key);

  @override
  _MyNGOI createState() => new _MyNGOI(this.uid);
}

class _MyNGOI extends State<MyNGOI> {
  var _name;
  var muser;
  var uname;
  var data = {};
  var user;
  final _id = TextEditingController();

  @override
  void dispose() {
    _id.dispose();
    super.dispose();
  }

  _MyNGOI(this.muser);

  Future<void> setData() async {
    FirebaseDatabase.instance
        .reference()
        .child("NGO")
        .child(muser)
        .once()
        .then((value) async {
      _name = value.value["name"];
      setState(() {});
    });
  }

  void updateData(var userT, var userI) {
    FirebaseDatabase.instance
        .reference()
        .child(userT)
        .child(userI)
        .child("Donation")
        .push()
        .set(data)
        .then((value) {
      FirebaseDatabase.instance
          .reference()
          .child(userT)
          .child(userI)
          .once()
          .then((value) async {
        var temp = data["amount"];
        List<dynamic> myKeys = value.value.keys.toList();
        if (myKeys.contains("amount")) {
          temp = temp + value.value["amount"];
        }
        FirebaseDatabase.instance
            .reference()
            .child(userT)
            .child(userI)
            .child("amount")
            .set(temp)
            .catchError((err) {
          _name = "ERROR";
          print(err.message);
          setState(() {});
        });
      }).catchError((err) {
        _name = "ERROR";
        print(err.message);
        setState(() {});
      });
    }).catchError((err) {
      _name = "ERROR";
      setState(() {});
    });
  }

  Future<void> abc() async {
    await FirebaseDatabase.instance
        .reference()
        .child("Donor")
        .child(user)
        .once()
        .then((value) async {
      uname = value.value["name"];
    }).catchError((err) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MySignIn()),
      );
    });
  }

  Future<void> setUser() async {
    user = FirebaseAuth.instance.currentUser;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (user == null && prefs.getStringList("Data") == null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MySignIn()),
      );
    } else if (user == null) {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: prefs.getStringList("Data")[0],
              password: prefs.getStringList("Data")[1])
          .then((value) async {
        user = value.user.uid;
        await abc();
      }).catchError((err) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MySignIn()),
        );
      });
    } else {
      user = user.uid;
      await abc();
    }
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await setData();
      await setUser();
      data["sid"] = user;
      data["rid"] = muser;
      data["rname"] = _name;
      data["sname"] = uname;
    });
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    super.initState();
  }

  var err = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.white,
        title: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new RaisedButton(
                child: new Text("Go Back"),
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
            ]),
        automaticallyImplyLeading: false,
      ),
      body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20.0)),
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
              "Name:\n" + ReCase(_name.toString()).titleCase,
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
            ),
            Padding(padding: EdgeInsets.only(top: 40.0)),
            new TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              keyboardType: TextInputType.number,
              inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
              controller: _id,
              style: new TextStyle(
                  color: const Color(0xFFffffff),
                  fontWeight: FontWeight.w200,
                  fontFamily: "Roboto"),
              decoration: new InputDecoration(
                hintText: "Amount to Donate?",
                labelText: "Amount",
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
            Padding(padding: EdgeInsets.only(top: 20.0)),
            new FloatingActionButton(
              child: Icon(Icons.send),
              onPressed: () {
                var amount = 0;
                if (_id.text.isNotEmpty) {
                  amount = int.parse(_id.text);
                  if (amount > 0) {
                    final DateTime now = DateTime.now().toLocal();
                    data["date"] = DateFormat.jm().format(now) +
                        DateFormat(' | EEE d MMM yyyy').format(now);
                    data["amount"] = amount;
                    updateData("NGO", data["rid"]);
                    updateData("Donor", data["sid"]);
                    setState(() {
                      err = "Done";
                    });
                  } else {
                    setState(() {
                      err = "Amount must be positive";
                    });
                  }
                } else {
                  setState(() {
                    err = "Pls Fill Amount";
                  });
                }
              },
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
              onPressed: () async {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MyDStatement()),
                  );
                });
              },
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
