import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => new _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool enabled = false;
  bool display = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _nameFocusNode = FocusNode();

  String name;

  Widget _buildDrawer(BuildContext context, MainModel model) {
    return Drawer(
      child: Column(children: model.listTiles),
    );
  }

  Widget _nameForm(MainModel model) {
    return Column(
      children: [
        TextFormField(
          enabled: enabled,
          validator: (String value) {},
          focusNode: _nameFocusNode,
          onSaved: (String value) {
            name = value.trim();
          },
          decoration: InputDecoration(
            labelText: 'Name: ' + model.user.name,
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget idForm(MainModel model) {
    return TextFormField(
      enabled: false,
      decoration: InputDecoration(
        labelText: 'ID: ' + model.user.id.toString(),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget statusForm(MainModel model) {
    return TextFormField(
      enabled: false,
      decoration: InputDecoration(
        labelText: model.user.manager ? 'Status: Manager' : 'Status: Employee',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget pinForm(MainModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          obscureText: true,
          enabled: false,
          decoration: InputDecoration(
            labelText: display ? 'PIN: ' + model.user.pin : 'PIN: ****',
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        FlatButton(
          child: !display
              ? Text(
                  'Show PIN',
                  style: TextStyle(fontSize: 12.0),
                )
              : Text(
                  'Hide PIN',
                  style: TextStyle(fontSize: 12.0),
                ),
          onPressed: () {
            setState(() {
              display = !display;
            });
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30.0),
        child: Form(
          key: _formKey,
          child: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
              return Column(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _nameForm(model),
                  SizedBox(height: 5.0),
                  idForm(model),
                  SizedBox(height: 5.0),
                  statusForm(model),
                  SizedBox(height: 5.0),
                  pinForm(model),
                  SizedBox(height: 5.0),
                  FlatButton(
                    textColor: Theme.of(context).accentColor,
                    child: Text('Change PIN'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/change_pin');
                    },
                  ),
                  Expanded(
                      child: Container(
                    margin: EdgeInsets.only(bottom: 50.0),
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        child: Text('Logout'),
                        color: Colors.white,
                        textColor: Colors.red,
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/');
                        },
                      ),
                    ),
                  )),
                ],
              );
            },
          ),
        ),
      ),
      drawer: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return _buildDrawer(context, model);
        },
      ),
    );
  }
}
