import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  print(_prefs.getString('token').toString());
  return _prefs.getString('token').toString();
}

class ApiService {
  static String url = "https://smartboi.herokuapp.com/api/";

  static Future<dynamic> getList(String token) async {
    try {
      final response = await http.get(Uri.encodeFull('${url}user'),
          headers: {'Authorization': 'Token $token'});
      return (response.body);
    } catch (ex) {
      return null;
    }
  }

  static Future<dynamic> loginPost(Map<String, String> loginCred) async {
    try {
      final response = await http.post(
        Uri.encodeFull('https://smartboi.herokuapp.com/api/login'),
        body: jsonEncode(loginCred),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.body.contains('token')) {
        print(response.body);
        return (json.decode(response.body)['token']);
      } else {
        print('Invalid Cred');
        return 'Error';
      }
    } catch (e) {
      print('No Internet');
      return null;
    }
  }

  static Future<dynamic> isAdmin() async {
    String _token = await getToken();

    final response = await http.get(
        Uri.encodeFull('https://smartboi.herokuapp.com/api/user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Token $_token',
        });

    var jsonData = json.decode(response.body)['is_admin'];
    return jsonData;
  }
}
