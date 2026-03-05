import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

class CreateSchedulePage extends StatefulWidget {
  const CreateSchedulePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return CreateSchedulePageState();
  }
}

class CreateSchedulePageState extends State<CreateSchedulePage> {
  Container _buildEmployeeData(String name, String data) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      color: Colors.black.withValues(alpha:0.5),
      padding: const EdgeInsets.only(top: 5.0),
      child: Column(
        children: <Widget>[
          Text(
            name,
            style: const TextStyle(fontSize: 12.0, color: Colors.white),
          ),
          Text(
            data,
            style: const TextStyle(fontSize: 10.0, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Container _buildEmployeeName(String name, bool enlarged) {
    return Container(
      margin: const EdgeInsets.all(4.0),
      padding: const EdgeInsets.only(top: 5.0),
      color: enlarged ? Colors.blueGrey : Colors.white.withValues(alpha:0.4),
      child: Column(
        children: <Widget>[
          Center(
            child: Text(
              name,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: enlarged ? 18.0 : 12.0,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Expanded _buildDragTargets(
      String acceptedData, List<String?> employeeData, MainModel model) {
    employeeData = model.employeeData;
    int count = 0;
    bool firstBuild = false;
    bool allow = false;

    return Expanded(
        flex: 2,
        child: GridView.count(
          primary: true,
          childAspectRatio: 2.0,
          crossAxisCount: 4,
          children: List.generate(
            model.employees.length,
            (int index) {
              return DragTarget<String>(
                builder: (BuildContext context, List<String?> accepted,
                    List<dynamic> rejected) {
                  if (count >= model.employees.length) {
                    firstBuild = !firstBuild;
                  }
                  if (count < model.employees.length && model.rebuild) {
                    count++;
                  }

                  if (count < model.employees.length && !model.rebuild) {
                    count++;
                    return _buildEmployeeName(
                        model.employees[index].name, false);
                  } else if (firstBuild) {
                    return _buildEmployeeName(
                        model.employees[index].name, true);
                  } else if (allow) {
                    allow = false;
                    employeeData[index] = acceptedData;
                    model.setEmployeeData(employeeData);
                    return _buildEmployeeData(
                        model.employees[index].name, employeeData[index] ?? '');
                  } else {
                    return employeeData[index] == null
                        ? _buildEmployeeName(model.employees[index].name, false)
                        : _buildEmployeeData(
                            model.employees[index].name, employeeData[index] ?? '');
                  }
                },
                onAcceptWithDetails: (DragTargetDetails<String> details) {
                  allow = true;
                  acceptedData = details.data;
                },
              );
            },
          ),
        ));
  }

  final List<String> _weekdayShifts = [
    '9.0 | 17.0',
    '9.5 | 16.0',
    '9.5 | 16.0',
    '12.0 | 19.0',
    '13.0 | 19.5',
    '13.0 | 20.0',
    '13.0 | 21.0',
    '14.0 | 19.5',
    '16.0 | 20.0',
    '16.0 | 22.0',
    '17.0 | 22.0',
    '18.0 | 22.0',
  ];
  final List<String> _fridayShifts = [
    '9.0 | 17.0',
    '9.5 | 17.0',
    '13.0 | 19.0',
    '13.0 | 20.0',
    '13.0 | 21.0',
    '17.0 | 22.0',
    '17.0 | 23.0',
    '18.0 | 23.0',
    '19.0 | 23.0',
  ];
  final List<String> _saturdayShifts = [
    '9.0 | 16.5',
    '9.5 | 16.5',
    '11.0 | 16.5',
    '12.0 | 20.0',
    '12.5 | 17.0',
    '12.5 | 20.5',
    '13.0 | 17.0',
    '13.0 | 21.0',
    '14.0 | 19.5',
    '16.5 | 23.0',
    '19.0 | 23.0',
  ];
  final List<String> _sundayShifts = [
    '10.5 | 18.0',
    '11.0 | 15.0',
    '11.0 | 16.0',
    '11.0 | 18.0',
    '11.5 | 18.0',
    '12.0 | 18.0',
    '13.0 | 18.0',
    '14.0 | 18.0',
    '14.5 | 18.0',
  ];

  Widget _buildDraggables(MainModel model) {
    List<String> returnedTimes = [];
    String start = '';
    String end = '';
    ScrollController controller = ScrollController();

    if (model.countDay < 4) {
      returnedTimes = _weekdayShifts;
    } else if (model.countDay == 4) {
      returnedTimes = _fridayShifts;
    } else if (model.countDay == 5) {
      returnedTimes = _saturdayShifts;
    } else {
      returnedTimes = _sundayShifts;
    }
    return Expanded(
      flex: 1,
      child: DraggableScrollbar.arrows(
        padding: const EdgeInsets.only(right: 3.0),
        backgroundColor: Colors.black54,
        alwaysVisibleScrollThumb: true,
        controller: controller,
        child: GridView.count(
          padding: const EdgeInsets.only(right: 25.0),
          controller: controller,
          primary: false,
          childAspectRatio: 2.0,
          crossAxisCount: 3,
          children: List.generate(
            returnedTimes.length + 1,
            (int index) {
              return Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.blue),
                child: index < returnedTimes.length
                    ? Draggable<String>(
                        data: returnedTimes[index],
                        feedback: Material(
                          color: Colors.blue.withValues(alpha:0.3),
                          child: Center(
                            child: Text(
                              returnedTimes[index],
                            ),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Text(
                              returnedTimes[index],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                    : TextButton(
                        child: const Text(
                          'Custom',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                model.rebuild = true;
                                return SimpleDialog(
                                  title: const Text('Add shift'),
                                  children: <Widget>[
                                    SimpleDialogOption(
                                      child: TextField(
                                        onChanged: (String value) {
                                          start = value;
                                          model.rebuild = true;
                                        },
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                                decimal: true),
                                        decoration: const InputDecoration(
                                          labelText: 'Start time',
                                        ),
                                      ),
                                    ),
                                    SimpleDialogOption(
                                      child: TextField(
                                        onChanged: (String value) {
                                          end = value;
                                          model.rebuild = true;
                                        },
                                        keyboardType:
                                            const TextInputType.numberWithOptions(
                                                decimal: true),
                                        decoration: const InputDecoration(
                                          labelText: 'End time',
                                        ),
                                      ),
                                    ),
                                    SimpleDialogOption(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              if (start.trim() != '' &&
                                                  end.trim() != '') {
                                                if (model.countDay < 4) {
                                                  _weekdayShifts
                                                      .add('$start | $end');
                                                } else if (model.countDay ==
                                                    4) {
                                                  _fridayShifts
                                                      .add('$start | $end');
                                                } else if (model.countDay ==
                                                    5) {
                                                  _saturdayShifts
                                                      .add('$start | $end');
                                                } else {
                                                  _sundayShifts
                                                      .add('$start | $end');
                                                }

                                                Navigator.pop(context);
                                              }
                                            },
                                            child: const Text('Confirm'),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildDate(MainModel model, bool selected) {
    return Text(
      model.tempDate.day.toString(),
      style: TextStyle(
          color: Colors.white,
          fontSize: selected ? 16.0 : 14.0,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal),
    );
  }

  Widget container(String text, bool isGrey) {
    isGrey = true;
    return Container(
        color: Colors.white.withValues(alpha:0.9),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 9.0),
          ),
        ));
  }

  void _buildSchedule(MainModel model) {
    model.temporaryDate = model.savedDate.subtract(const Duration(days: 1));
    int dayOfWeek = 0;
    int employeeIndex = 0;
    int testIndex = -1;
    List<String?> data = List.filled((model.employees.length * 8) + 8, null);
    model.setData(data);
    for (var index = 0; index < data.length; index++) {
      if (index == 0) {
        data[0] = '';
      } else if (index < 8) {
        data[index] = '${model.tempDate.day}';
      } else if (index % 8 == 0) {
        testIndex = testIndex + 1;
        data[index] = model.employees[employeeIndex++].name;
      } else {
        String shift = '';

        if (model.schedule[dayOfWeek][testIndex] != null) {
          shift = model.schedule[dayOfWeek][testIndex];
        }
        dayOfWeek++;

        if (dayOfWeek == 7) {
          dayOfWeek = 0;
        }
        data[index] = shift;
      }
    }

    model.setData(data);
  }

  final List<bool> _selected = [true, false, false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    String acceptedData = '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Schedule'),
      ),
      body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget? child, MainModel model) {
        List<String?> employeeData = List.filled(model.employees.length, null);
        if (!model.rebuild) {
          model.setEmployeeData(employeeData);
        }

        if (_selected[0]) {
          List<dynamic> test = List.filled(model.employees.length, null);
          for (var i = 0; i < 8; i++) {
            model.schedule.add(test);
          }
        }
        DateTime dateSelected = model.savedDate;
        model.setTemporaryDate(dateSelected.subtract(const Duration(days: 1)));
        return Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background.png'),
            ),
          ),
          child: Column(children: <Widget>[
            SizedBox(
              height: 30.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(7, (int index) {
                  return buildDate(model, _selected[index]);
                }),
              ),
            ),
            _buildDragTargets(acceptedData, employeeData, model),
            _buildDraggables(model),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text('Exit'),
                    onPressed: () {
                      model.rebuild = false;
                      model.countDay = 0;
                      model.resetSchedule();
                      Navigator.pushReplacementNamed(context, '/schedule');
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Reset'),
                    onPressed: () => setState(() {
                          model.rebuild = false;
                        }),
                  ),
                  model.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          child: Text(model.countDay == 6 ? 'Confirm' : 'Next'),
                          onPressed: () {
                            model.rebuild = false;
                            model.addDay();
                            if (model.countDay == 7) {
                              _buildSchedule(model);
                              model.addSchedule().then((bool success) {
                                if (!mounted) return;
                                if (success) {
                                  model.countDay = 0;
                                  Navigator.pushReplacementNamed(
                                      context, '/schedule');
                                } else {
                                  Navigator.pushReplacementNamed(context, '/');
                                }
                              });
                            }

                            setState(() {
                              for (int i = 0; i < _selected.length; i++) {
                                if (_selected[i] && i != _selected.length - 1) {
                                  _selected[i] = false;
                                  _selected[i + 1] = true;
                                  break;
                                }
                              }
                            });
                          },
                        ),
                ]),
          ]),
        );
      }),
    );
  }
}
