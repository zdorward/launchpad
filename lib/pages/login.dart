import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../widgets/error.dart';

class LoginPage extends StatefulWidget {
  final MainModel model;

  LoginPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  initState() {
    widget.model.fetchEmployees().then((bool success) {
      if (!success) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return ShowErrorDialogue();
            });
      }
    });

    super.initState();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int index = -1;
  bool login = true;

  Widget _idTextFormField(MainModel model) {
    return TextFormField(
      validator: (String value) {
        for (int i = 0; i < model.employees.length; i++) {
          if (value.isEmpty) {
            return '';
          }

          if (model.employees[i].id == int.parse(value)) {
            index = i;
            login = true;
            break;
          } else {
            login = false;
          }
        }
        if (!login) {
          return 'Invalid ID';
        }
      },
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Employee ID',
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
    );
  }

  Widget _pinTextFormField(MainModel model) {
    return TextFormField(
      validator: (String value) {
        if (value.isEmpty) {
          return '';
        }
        if (index < 0) {
          return '';
        } else if (model.employees[index].pin != (value)) {
          return 'Invalid PIN';
        }
      },
      keyboardType: TextInputType.number,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'PIN',
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
    );
  }

  Widget _createAccountButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: Colors.black.withOpacity(0.2),
      onPressed: () {
        Navigator.pushNamed(context, '/create_account');
      },
      child: Text(
        'Create Account',
        style: TextStyle(color: Colors.white, fontSize: 11.0),
      ),
    );
  }

  Widget _loginButton(MainModel model) {
    return RaisedButton(
      color: Theme.of(context).primaryColor,
      child: Text('LOGIN'),
      onPressed: () {
        if (!_formKey.currentState.validate()) {
          return;
        }
        //_formKey.currentState.save();
        model.setUserIndex(index);
        model.setUser(model.employees[index]);
        model.setWidth(MediaQuery.of(context).size.width);

        Navigator.pushReplacementNamed(context, '/schedule');
      },
    );
  }

  Widget centeredColumn() {
    return Form(
        key: _formKey,
        child: ScopedModelDescendant(
          builder: (BuildContext context, Widget child, MainModel model) {
            return Column(
              children: <Widget>[
                _idTextFormField(model),
                Container(
                  margin: EdgeInsets.only(top: 10.0, bottom: 15.0),
                  child: _pinTextFormField(model),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 25.0),
                  child: SizedBox(
                    height: 25.0,
                    child: _createAccountButton(),
                  ),
                ),
                _loginButton(model),
              ],
            );
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/neon.jpeg'),
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.75), BlendMode.dstATop),
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: centeredColumn(),
          ),
        ),
      ),
    );
  }
}
