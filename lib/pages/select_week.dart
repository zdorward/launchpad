import 'dart:async';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class SelectDayPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SelectDayPageState();
}

class _SelectDayPageState extends State<SelectDayPage> {
  DateTime _firstDate = DateTime.now().subtract(Duration( days: 7));
  DateTime _date = DateTime.now();
  DateTime limit = DateTime.now().add(Duration(days: 100));
 
  Future<Null> _selectDate(BuildContext context, MainModel model) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: _firstDate,
      initialDate: _date,
      lastDate: limit,
    );
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;

        model.setDate(picked.add(Duration(hours: 2)));
      });
    }
  }

  Widget _buildDrawer(BuildContext context, MainModel model) {
    return Drawer(
      child: Column(children: model.listTiles),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Date Selection'),
        ),
        drawer: _buildDrawer(context, model),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background.png'),
              // colorFilter: ColorFilter.mode(
              //     Colors.black.withOpacity(0.9), BlendMode.dstATop),
            ),
          ),
          //margin: EdgeInsets.only(bottom: 100.0, top: 30.0),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: RaisedButton(
                        child: Text('Select Date'),
                        onPressed: () {
                          _selectDate(context, model);
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Date selected: ${_date.day.toString()}/${_date.month.toString()}/${_date.year.toString()}',
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 50.0),
                child: RaisedButton(
                  child: Text('Next'),
                  onPressed: () {
                    bool access = true;

                    for (var i = 0; i < model.allSchedules.length; i++) {
                      DateTime compareDate = model.savedDate.subtract(
                          Duration(days: model.savedDate.weekday - 1));
                      if ((compareDate.year ==
                              model.allSchedules[i].firstDate.year) &&
                          ((compareDate.month ==
                              model.allSchedules[i].firstDate.month)) &&
                          (compareDate.day ==
                              model.allSchedules[i].firstDate.day)) {
                        access = false;
                      }
                    }
                    if (access) {
                      Navigator.pushReplacementNamed(
                          context, '/create_schedule');
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                               
                              title: Text('Error'),
                              content: Text(
                                  'A schedule with days during this week has already been made.'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('OK'),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            );
                          });
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
