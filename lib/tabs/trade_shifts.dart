import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class TradeShiftsTab extends StatefulWidget {
  @override
  _TradeShiftsTabState createState() => new _TradeShiftsTabState();
}

class _TradeShiftsTabState extends State<TradeShiftsTab> {
  DateTime _firstDate;
  DateTime _date;
  DateTime limit;

  @override
  initState() {
    _firstDate = DateTime.now().subtract(Duration(days: 1));
    _date = DateTime.now();
    limit = _firstDate.add(Duration(days: 100));
    super.initState();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: _firstDate,
      initialDate: _date,
      lastDate: limit,
    );
    if (picked != null) {
      setState(() {
        _date = picked;
      });
    }
  }

  String _name;

  bool validate(MainModel model) {
    bool test1 = false;
    bool test2 = false;
    if (_name == null || _name == model.user.name) {
      return false;
    }
    if (model.allSchedules.length <= 0) {
      return false;
    }

    for (var i = 0; i < model.allSchedules.length; i++) {
      DateTime compareDate = _date.subtract(Duration(days: _date.weekday - 1));
      if ((compareDate.year == model.allSchedules[i].firstDate.year) &&
          ((compareDate.month == model.allSchedules[i].firstDate.month)) &&
          (compareDate.day == model.allSchedules[i].firstDate.day)) {
        for (int j = 0; j < model.allSchedules[i].employeeNames.length; j++) {
          if (_name == model.allSchedules[i].employeeNames[j]) {
            test1 = true;
          }
          if (model.user.name == model.allSchedules[i].employeeNames[j]) {
            test2 = true;
          }
        }
      }
    }

    if (test1 && test2) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: 10.0, right: 20.0, left: 20.0, bottom: 10.0),
      child: Center(
        child: ScopedModelDescendant(
            builder: (BuildContext context, Widget child, MainModel model) {
          if (model.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: <Widget>[
                Text(
                    'Select the employee that you are trading shifts with and the date you want to trade shifts.'),
                Divider(),
                Expanded(
                    child: GridView.count(
                        childAspectRatio: 3.0,
                        crossAxisCount: 2,
                        primary: false,
                        children: List<RadioListTile>.generate(
                            model.employees.length, (int index) {
                          return RadioListTile(
                            title: Text(model.employees[index].name),
                            value: model.employees[index].name,
                            groupValue: _name,
                            onChanged: (dynamic value) {
                              setState(() {
                                _name = value;
                              });
                            },
                          );
                        }))),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      child: Text('Select Date'),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    RaisedButton(
                      child: Text('Confirm'),
                      onPressed: () {
                        if (validate(model)) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Trade Shifts'),
                                  content: Text(
                                      'Are you sure you want to trade shifts with $_name on ${model.days[_date.weekday]}, ${model.months[_date.month]} ${_date.day}?'),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('NO'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('YES'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        model.isLoading = true;

                                        model
                                            .fetchEmployees()
                                            .then((bool success) {
                                          if (success) {
                                            model
                                                .createRequest(_name, _date)
                                                .then((bool success) {
                                              model.isLoading = false;
                                            });
                                          } else {
                                            model.isLoading = false;

                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Error'),
                                                    content: Text(
                                                        'An error occurred when switching shifts. Check your network connection and make sure you have selected valid data.'),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('OK'),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          }
                                        });
                                      },
                                    ),
                                  ],
                                );
                              });
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Error'),
                                  content: Text(
                                      'Make sure an employee and a valid date are selected'),
                                  actions: <Widget>[
                                    FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                    )
                  ],
                )
              ],
            );
          }
        }),
      ),
    );
  }
}
