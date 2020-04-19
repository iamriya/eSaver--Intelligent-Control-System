import 'package:esaver/classes/api_response.dart';
import 'package:esaver/classes/connection.dart';
import 'package:esaver/classes/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:esaver/utilities/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Lights extends StatefulWidget {
  final int id;
  final String location;

  Lights(this.id, this.location);

  @override
  _LightsState createState() => _LightsState(this.id, this.location);
}

List<User> grantedUsers;

class _LightsState extends State<Lights> {
  int id;
  String location;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  _LightsState(this.id, this.location);
  Future<String> getToken() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('token');
  }

  void initState() {
    super.initState();
    setState(() {
      _getConnections();
    });
  }

  Future<List<Connection>> _getConnections() async {
    String _token = await getToken();
    // print('Token $_token');
    var response = await http.get(
        Uri.encodeFull('https://smartboi.herokuapp.com/api/location/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $_token',
        });

    var jsonData = json.decode(response.body)['connections'];
    print(jsonData);

    List<Connection> connections = [];

    for (var u in jsonData) {
      Connection connection = Connection(
          u['id'], u['connection_name'], u['connection_pin'],u['connection_url'], u['is_high']);
      connections.add(connection);
    }
    return connections;
  }

  Future _getStatus(
      String connenctin_url, bool is_high, int connection_pin) async {
    String status;
    if (is_high == true) {
      return await http.get(
        Uri.encodeFull('${connenctin_url}on/$connection_pin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token 952c3f823d3c9926885490ddd825a11646832f73',
        },
      );
      // status = 'on';
    } else {
      return await http.get(
        Uri.encodeFull('${connenctin_url}off/$connection_pin'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token 952c3f823d3c9926885490ddd825a11646832f73',
        },
      );
      // status = 'off';
    }
  }

  Future<APIResponse<bool>> updateNotes(int ids, Changes item) async {
    String _token = await getToken();
    print('Token $_token');
    return await http
        .put('https://smartboi.herokuapp.com/api/connection/$ids',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Token $_token',
            },
            body: json.encode(item.toJson()))
        .then((data) async {
      if (data.statusCode == 204) {
        await _getConnections();
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    }).catchError((_) =>
            APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(title: Text("Components")),
        body: Container(
          margin: EdgeInsets.all(15),
          color: Color(0xfff5f5f5),
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      location,
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.blue,
                  // indent: 25.0,
                  // endIndent: 25.0,
                  height: 25,
                  thickness: 5,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 10.0,
                    child: FutureBuilder(
                        future: _getConnections(),
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
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  // print(index);

                                  return Column(
                                    children: <Widget>[
                                      ListTile(
                                        leading: Icon(Icons.album, size: 25),
                                        title: Text(snapshot
                                            .data[index].connection_name),
                                        trailing: Switch(
                                          value: snapshot.data[index].is_high,
                                          onChanged: (value) {
                                            print(snapshot.data[index].is_high);
                                            print(
                                                "main file data must be here");
                                            final note = Changes(
                                              is_high: value,
                                            );
                                            setState(
                                              () {
                                                // value = snapshot.data[index].is_high;
                                                updateNotes(
                                                    snapshot.data[index].id,
                                                    note);

                                                //  _likeVisible1 = value;
                                              },
                                            );
                                            displaySnackBar(scaffoldKey, 'Successful!', 'OK');
                                            print(snapshot.data[index].is_high);
                                            _getStatus(
                                                snapshot
                                                    .data[index].connection_url,
                                                value,
                                                snapshot.data[index]
                                                    .connection_pin);
                                            print("main file data be here");
                                          },
                                          activeTrackColor:
                                              Colors.lightGreenAccent,
                                          activeColor: Colors.green,
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                        color: Colors.grey.shade700,
                                      )
                                    ],
                                  );
                                });
                          }
                        }),
                  ),
                ),
                // DisplayListView(), //data in static form if user want to fed input locally
                // ListViewExample(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ListViewExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: DisplayListView(),
    );
  }
}

class ListViewModel {
  final String title;
  final String subtitle;
  final String avatarURL;

  ListViewModel({this.title, this.subtitle, this.avatarURL});
}

List listViewData = [
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "1",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "2",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "3",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "4",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "5",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "6",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "7",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "8",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "9",
  ),
  ListViewModel(
    title: "Group",
    subtitle: "Group Category",
    avatarURL: "10",
  ),
];

class DisplayListView extends StatefulWidget {
  @override
  _DisplayListViewState createState() => _DisplayListViewState();
}

class _DisplayListViewState extends State {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: listViewData.length,
      itemBuilder: (context, int i) => Column(
        children: [
          new ListTile(
            leading: new CircleAvatar(child: Text(listViewData[i].avatarURL)),
            title: new Text(listViewData[i].title),
            subtitle: new Text(listViewData[i].subtitle),
            onTap: () {},
            onLongPress: () {
              print(
                Text("Long Pressed"),
              );
            },
          ),
        ],
      ),
    );
  }
}
