import 'package:flutter/material.dart';

displaySnackBar(GlobalKey<ScaffoldState> key, content, String label) {
  final snackBar = SnackBar(
    content: Text(content),
    action: SnackBarAction(label: label, onPressed: () {}),
  );
  key.currentState.showSnackBar(snackBar);
}
