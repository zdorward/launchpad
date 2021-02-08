import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ChangePINPage extends StatefulWidget {
  @override
  _ChangePINPageState createState() => new _ChangePINPageState();
}

class _ChangePINPageState extends State<ChangePINPage> {
  final GlobalKey<FormState> _passFormKey = GlobalKey<FormState>();

  String oldPass = '';
  String newPass1 = '';
  String newPass2 = '';

  final _oldPassFocusNode = FocusNode();
  final _confirmNewPassFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change PIN'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30.0, left: 10.0, right: 10.0),
        child: Form(
          key: _passFormKey,
          child: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Column(
                children: <Widget>[
                  TextFormField(
                    obscureText: true,
                    focusNode: _oldPassFocusNode,
                    validator: (String value) {
                      if (value != model.user.pin || value == '') {
                        return 'Incorrect PIN';
                      }
                    },
                    keyboardType: TextInputType.number,
                    onSaved: (String value) {
                      oldPass = (value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Old PIN',
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    focusNode: _confirmNewPassFocusNode,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      newPass1 = (value);
                    },
                    decoration: InputDecoration(
                      labelText: 'New PIN',
                    ),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (String value) {
                      if (value != newPass1 || value == '') {
                        return 'PINs do not match';
                      }
                    },
                    keyboardType: TextInputType.number,
                    onSaved: (String value) {
                      newPass2 = (value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Confirm PIN',
                    ),
                  ),
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                          Navigator.pop(context);
                        },
                        child: Text('Cancel'),
                      ),
                      FlatButton(
                        textColor: Theme.of(context).accentColor,
                        onPressed: () {
                          _passFormKey.currentState.save();
                          if (!_passFormKey.currentState.validate()) {
                            return;
                          }

                          model.changePIN(model.userIndex, newPass1);
                          model.updateUser(model.userIndex);

                          Navigator.pop(context);
                        },
                        child: Text('Confirm'),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
