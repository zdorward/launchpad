import 'package:flutter/material.dart';

class ShowErrorDialogue extends StatelessWidget {
  const ShowErrorDialogue({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Network Error'),
      content:
          const Text('Please contact a manager and let them know what went wrong'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
          child: const Text('Okay'),
        )
      ],
    );
  }
}
