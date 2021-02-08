import 'package:flutter/material.dart';

class ShowErrorDialogue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Network Error'),
      content:
          Text('Please contact a manager and let them know what went wrong'),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          child: Text('Okay'),
        )
      ],
    );
  }
}
