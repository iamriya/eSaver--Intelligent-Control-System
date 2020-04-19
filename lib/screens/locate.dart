import 'package:esaver/screens/Light.dart';
import 'package:esaver/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:esaver/classes/Location.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esaver/screens/permissions.dart';

class Locate extends StatefulWidget {
  final bool isAdmin;
  Locate(this.isAdmin);
  @override
  _LocateState createState() => _LocateState(this.isAdmin);
}

Future<String> getToken() async {
  final _prefs = await SharedPreferences.getInstance();
  return _prefs.getString('token');
}

_setToken(String token) async {
  final _prefs = await SharedPreferences.getInstance();
  await _prefs.setString('token', token);
}

Future<List<Location>> _getLocation() async {
  String _token = await getToken();
  print('Token $_token');
  print('----------------------------');
  var response = await http
      .get(Uri.encodeFull('https://smartboi.herokuapp.com/api/user'), headers: {
    'Content-Type': 'application/json',
    'Authorization': 'Token $_token',
  });

  var jsonData = json.decode(response.body)['locations'];

  List<Location> locations = [];

  for (var l in jsonData) {
    Location locate = Location(
        l['id'], l['location_name'], l['incharge_name'], l['connections']);
    locations.add(locate);
  }
  return locations;
}

class _LocateState extends State<Locate> {
  bool isAdmin;
  _LocateState(this.isAdmin);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("eSaver"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.launch),
              tooltip: 'Confirm Sign Out',
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: Text('Sign out'),
                    content: Text('Would you like to sign out?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(context),
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          _setToken(null);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: <Widget>[
                              Text(
                                "Hello,",
                                style: TextStyle(fontSize: 30),
                              ),
                            ],
                          ),
                        )),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Have a Nice Day!",
                          style: TextStyle(fontSize: 16),
                        )),
                    Divider(
                      color: Colors.blue,
                      height: 25,
                      thickness: 5,
                    ),

                    SizedBox(
                      height: 20,
                    ),

//                    Padding(
//                      padding: const EdgeInsets.only(
//                          top: 8.0, bottom: 8.0, left: 12.0, right: 12.0),
//                      child: Container(
//                        child: TextFormField(
//                          decoration: InputDecoration(
//                            fillColor: Colors.white,
//                            border: OutlineInputBorder(
//                              borderRadius: const BorderRadius.all(
//                                const Radius.circular(25.0),
//                              ),
//                            ),
//                            hintStyle: TextStyle(fontSize: 17),
//                            hintText: 'Search your location',
//                            suffixIcon: Icon(Icons.search),
//                            contentPadding: EdgeInsets.all(20),
//                          ),
//                        ),
//                      ),
//                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Locations",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 10.0,
                      child: FutureBuilder(
                        future: _getLocation(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.data == null) {
                            return Container(
                              child: Center(
                                child: Text('Loading...'),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.computer, size: 25),
                                      title: Text(
                                          snapshot.data[index].location_name),
                                      trailing: IconButton(
                                        icon: Icon(isAdmin
                                            ? Icons.person_add
                                            : Icons.chevron_right),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => isAdmin
                                                    ? Permissions(
                                                        snapshot.data[index].id,
                                                        snapshot.data[index]
                                                            .location_name)
                                                    : Lights(
                                                        snapshot.data[index].id,
                                                        snapshot.data[index]
                                                            .location_name)),
                                          );
                                        },
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Lights(
                                                snapshot.data[index].id,
                                                snapshot
                                                    .data[index].location_name),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
