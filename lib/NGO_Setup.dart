import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ngo_donor_connect/Donor_Home.dart';
import 'package:ngo_donor_connect/MainPage.dart';
import 'package:ngo_donor_connect/SignIn.dart';
import 'package:ngo_donor_connect/StatementDonor.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
              "Description :",
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: 60,
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
              icon: Icon(Icons.settings),
              disabledColor: Colors.green,
              onPressed: null,
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
