import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../widgets/error.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateAccountPageState();
  }
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String groupValue = 'employee';

  final _nameFocusNode = FocusNode();
  final _idFocusNode = FocusNode();
  final _pinFocusNode = FocusNode();
  final _accessCodeFocusNode = FocusNode();

  String name;
  int id;
  String pin;
  String attemptedAccessCode;
  bool manager = false;

  String _employeeAccessCode = 'UvdX83u';
  String _managerAccessCode = 'QeFH15f';

  Widget space(double height) {
    return SizedBox(height: height);
  }

  Widget _radioButton() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Radio(
              value: 'employee',
              groupValue: groupValue,
              onChanged: (String value) {
                manager = false;
                setState(() {
                  groupValue = 'employee';
                });
              },
            ),
            SizedBox(
              width: 50.0,
            ),
            Radio(
              value: 'manager',
              groupValue: groupValue,
              onChanged: (String value) {
                manager = true;
                setState(() {
                  groupValue = 'manager';
                });
              },
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Employee'),
            SizedBox(
              width: 40.0,
            ),
            Text('Manager')
          ],
        )
      ],
    );
  }

  _createAccount(MainModel model) {
    model.addEmployee(name, id, pin, manager).then((bool success) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ShowErrorDialogue();
            });
      }
    });
  }

  Widget nameTextField(MainModel model) {
    bool create = true;
    return TextFormField(
      validator: (String value) {
        for (int i = 0; i < model.employees.length; i++) {
          if (model.employees[i].name.toLowerCase() == value.toLowerCase()) {
            create = false;
            break;
          }
        }
        if (!create) {
          return 'Name already in use';
        }
      },
      focusNode: _nameFocusNode,
      onSaved: (String value) {
        name = value.trim();
      },
      decoration: InputDecoration(
        labelText: 'First name',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget idTextField(MainModel model) {
    bool create = true;
    return TextFormField(
      validator: (String value) {
        for (int i = 0; i < model.employees.length; i++) {
          if (model.employees[i].id == int.parse(value)) {
            create = false;
            break;
          }
        }
        if (!create) {
          return 'ID already in use';
        }
      },
      focusNode: _idFocusNode,
      onSaved: (String value) {
        id = int.parse(value);
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Employee ID',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget pinTextField() {
    return TextFormField(
      validator: (String value) {
        if (value.length != 4) {
          return 'PIN must be 4 digits';
        }
      },
      focusNode: _pinFocusNode,
      onSaved: (String value) {
        pin = value;
      },
      obscureText: true,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'PIN',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget accessCodeTextField() {
    return TextFormField(
      validator: (String value) {
        if ((manager && attemptedAccessCode != _managerAccessCode) ||
            (!manager && attemptedAccessCode != _employeeAccessCode)) {
          return 'Invalid access code';
        }
      },
      obscureText: true,
      focusNode: _accessCodeFocusNode,
      onSaved: (String value) {
        attemptedAccessCode = value;
      },
      decoration: InputDecoration(
        labelText: 'Access Code',
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Create Account'),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              child: Form(
                key: _formKey,
                child: ScopedModelDescendant<MainModel>(builder:
                    (BuildContext context, Widget child, MainModel model) {
                  return Column(
                    children: [
                      Container(
                        child: _radioButton(),
                      ),
                      SizedBox(
                        height: 70.0,
                      ),
                      nameTextField(model),
                      space(10.0),
                      idTextField(model),
                      space(10.0),
                      pinTextField(),
                      space(10.0),
                      accessCodeTextField(),
                      space(30.0),
                      RaisedButton(
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          _formKey.currentState.save();
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _createAccount(model);
                        },
                        child: Text('Create Account'),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
