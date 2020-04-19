import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:esaver/screens/locate.dart';
import 'package:esaver/classes/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  bool showSpinner = false;
  bool _visible;
  String _userid;
  String _password;
  List data;
  TextEditingController uidController = TextEditingController();
  TextEditingController pwController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _setToken(null);
    _visible = false;
  }

  _setToken(String token) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString('token', token);
  }

  _setAdmin(bool isAdmin) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setBool('is_admin', isAdmin);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: Image.asset(
                        'assets/login.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    Column(children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(10.0),
                        padding: EdgeInsets.only(left: 5.0, right: 2),
                        color: Colors.white24,
                        child: TextFormField(
                          onChanged: (value) {
                            _userid = value;
                          },
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email, color: Colors.blue),
                            //border: InputBorder.none,
                            hintText: "User ID",
                            hintStyle: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        padding: EdgeInsets.only(left: 5.0, right: 2),
                        color: Colors.white24,
                        child: TextFormField(
                          onChanged: (value) {
                            _password = value;
                          },
                          obscureText: _visible == true ? false : true,
                          style: TextStyle(color: Colors.blue, fontSize: 20),
                          maxLines: 1,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock, color: Colors.blue),
                            suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                },
                                child: Icon(
                                  _visible == true
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue,
                                )),
                            hintText: "Password",
                            hintStyle:
                                TextStyle(color: Colors.blue, fontSize: 20),
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          "Forgot Password ?",
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 40,
                        width: double.infinity,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0)),
                          padding: EdgeInsets.all(7.0),
                          color: Colors.blue,
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            final loginCredentials = {
                              'username': _userid,
                              'password': _password,
                            };

                            var _loginCred =
                                await ApiService.loginPost(loginCredentials);
                            setState(() {
                              showSpinner = false;
                            });

                            if (_loginCred == null) {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text('No Internet!'),
                                        content: Text(
                                            'Please check your internet connection and try again.'),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ],
                                      ));
                            } else if (_loginCred == 'Error') {
                              showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                        title: Text('Invalid Credentials!'),
                                        content: Text(
                                            'Please check your credentials and try again.'),
                                        actions: <Widget>[
                                          FlatButton(
                                              child: Text('OK'),
                                              onPressed: () {
                                                Navigator.pop(context);
                                              })
                                        ],
                                      ));
                            } else {
                              _setToken(_loginCred.toString());
                              bool isAdmin = await ApiService.isAdmin();
                              _setAdmin(isAdmin);
                              Navigator.pop(context);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Locate(isAdmin)));
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20)
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
