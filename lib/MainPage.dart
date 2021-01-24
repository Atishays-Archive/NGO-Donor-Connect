import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart' as lnt;
import 'package:ngo_donor_connect/Donor_Home.dart';
import 'package:ngo_donor_connect/NGO_info.dart';
import 'package:ngo_donor_connect/StatementDonor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SignIn.dart';

class MyMainPage extends StatefulWidget {
  final double lat;
  final double long;

  MyMainPage({Key key, @required this.lat, @required this.long})
      : super(key: key);

  @override
  _MyMainPageState createState() => new _MyMainPageState(lat, long);
}

class _MyMainPageState extends State<MyMainPage> {
  double lati;
  double longi;
  List<dynamic> data = [];

  _MyMainPageState(this.lati, this.longi);

  void setData() {
    FirebaseDatabase.instance.reference().child("NGO").once().then((value) {
      List<dynamic> myKeys = value.value.keys.toList();
      int temp = 20;
      if (myKeys.length < 20) {
        temp = myKeys.length;
      }
      int i;
      data = [];
      for (i = 0; i < temp; i++) {
        var tempD = {};
        tempD["id"] = myKeys[i];
        double tLat = value.value[myKeys[i]]["lat"].toDouble();
        tempD["lat"] = tLat;
        double tLong = value.value[myKeys[i]]["long"].toDouble();
        tempD["long"] = tLong;
        data.add(tempD);
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    setData();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Nearby NGOs"),
        automaticallyImplyLeading: false,
      ),
      body: new FlutterMap(
          options: new MapOptions(
              center: new lnt.LatLng(lati, longi),
              zoom: 15,
              minZoom: 2,
              maxZoom: 18),
          layers: [
            new TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']),
            new MarkerLayerOptions(markers: [
              for (var index = 0; index < data.length; index++)
                new Marker(
                  width: 45.0,
                  height: 45.0,
                  point: new lnt.LatLng(data[index]["lat"].toDouble(),
                      data[index]["long"].toDouble()),
                  builder: (ctx) => new Container(
                    height: 45,
                    width: 45,
                    child: IconButton(
                      icon: Icon(Icons.location_on, color: Colors.blue),
                      iconSize: 55,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MyNGOI(uid: data[index]["id"].toString())),
                        );
                      },
                    ),
                  ),
                ),
              new Marker(
                width: 45.0,
                height: 45.0,
                point: new lnt.LatLng(lati, longi),
                builder: (ctx) => new Container(
                  height: 45,
                  width: 45,
                  child: IconButton(
                    icon: Icon(Icons.location_on, color: Colors.red),
                    iconSize: 55,
                    onPressed: null,
                  ),
                ),
              ),
            ])
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
              onPressed: null,
            ),
            IconButton(
              icon: Icon(Icons.request_page_sharp),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyDStatement()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
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
