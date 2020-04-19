import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:esaver/screens/login_screen.dart';
import 'package:esaver/classes/api_service.dart';

class Controls extends StatefulWidget {
  final String location;

Controls(this.location);

  @override
  _ControlState createState() => _ControlState(this.location);
}

class _ControlState extends State<Controls> {
  String location;

  _ControlState(this.location);

  Future<String> getToken() async {
    final _prefs = await SharedPreferences.getInstance();
    return _prefs.getString('token');
  }
  _setToken (String token) async{
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('token', token);
  }

  String _token;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Controls'),
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
                                _token = null;
                                _setToken(_token);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginScreen()));
                              })
                        ],
                      ));
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Center(
                  child: Image.asset(
                'assets/controls.png',
                fit: BoxFit.contain,
              )),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    child: Card(
                      elevation: 20,
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                      child: Container(
                        height: 150,
                        width: 150,
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.lightbulb_outline,
                              color: Colors.white,
                              size: 50,
                            ),
                            Text(
                              'Lights',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 28),
                            )
                          ],
                        ),
                      ),
                    ),
                    onTap: () {},
                  ),
                  GestureDetector(
                      child: Card(
                          elevation: 20,
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          child: Container(
                            height: 150,
                            width: 150,
                            padding: EdgeInsets.all(30),
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.toys,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                Text(
                                  'Fans',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 28),
                                )
                              ],
                            ),
                          )),
                          onTap: () async{
                            _token = await getToken();
                            var hello = ApiService.getList(_token);
                            print("__________");
                            print(hello);
                            },
                          )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
