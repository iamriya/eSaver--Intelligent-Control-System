import 'package:esaver/screens/locate.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final _token = prefs.getString('token');
  final isAdmin = prefs.getBool('is_admin');

  runApp(MaterialApp(
    title: 'ESaver',
    home: _token == null ? LoginScreen() : Locate(isAdmin),
  ));
}
