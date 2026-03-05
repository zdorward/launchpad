import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

import '../models/shift.dart';

import '../widgets/error.dart';

class ShiftPoolPage extends StatefulWidget {
  final MainModel model;
  const ShiftPoolPage(this.model, {super.key});
  @override
  State<ShiftPoolPage> createState() => _ShiftPoolPageState();
}

class _ShiftPoolPageState extends State<ShiftPoolPage> {
  late DateTime _firstDate;
  late DateTime _date;
  late DateTime limit;

  @override
  initState() {
    _firstDate = DateTime.now().subtract(const Duration(days: 1));
    _date = DateTime.now();
    limit = _firstDate.add(const Duration(days: 100));

    super.initState();
    widget.model.fetchShifts().then((bool success) {
      if (!success && mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const ShowErrorDialogue();
            });
      }
    });
  }

  void showDeleteDialog(MainModel model, String name, DateTime date) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text(
                'Are you sure you want to remove your shift on ${model.months[date.month]} ${date.day} from the shift pool?'),
            actions: <Widget>[
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  model.isLoading = true;
                  Navigator.pop(context);
                  model.deleteShift(name, date);
                  model.isLoading = false;
                },
              )
            ],
          );
        });
  }

  void showTradeDialog(MainModel model, String name, DateTime date) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm Upload'),
            content: Text(
                'Are you sure you want to take $name\'s shift on ${model.months[date.month]} ${date.day}?'),
            actions: <Widget>[
              TextButton(
                child: const Text('NO'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('YES'),
                onPressed: () {
                  model.isLoading = true;
                  Navigator.pop(context);
                  model.tradeShifts(date, name);
                  model.deleteShift(name, date);
                  String dateString = '${date.month}/${date.day}/${date.year}';
                  model.addUpdate(name, model.user.name, dateString, context);
                  model.isLoading = false;
                },
              )
            ],
          );
        });
  }

  Widget listShifts(MainModel model, List<Shift> newShiftPool) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        DateTime date = newShiftPool[index].date;
        String name = newShiftPool[index].employeeName;
        String shift = newShiftPool[index].shift;
        return Column(
          children: <Widget>[
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(name),
              ),
              title: Text(
                  '${model.days[date.weekday]}, ${model.months[date.month]} ${date.day}, ${date.year}'),
              subtitle: Text(shift),
              trailing: name == model.user.name
                  ? (const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ))
                  : const Icon(
                      (Icons.check),
                      color: Colors.green,
                    ),
              onTap: () {
                if (name == model.user.name) {
                  showDeleteDialog(model, name, date);
                } else {
                  showTradeDialog(model, name, date);
                }
              },
            ),
            const Divider(),
          ],
        );
      },
      itemCount: newShiftPool.length,
    );
  }

  Widget _buildDrawer(BuildContext context, MainModel model) {
    return Drawer(
      child: Column(children: model.listTiles),
    );
  }

  Future<void> _selectDate(BuildContext context, MainModel model) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: _firstDate,
      initialDate: _date,
      lastDate: limit,
    );
    if (picked != null) {
      setState(() {
        _date = picked;

        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm Addition'),
                content: Text(
                    'Are you sure you want to add your shift on ${model.months[_date.month]} ${_date.day} to the shift pool?'),
                actions: <Widget>[
                  TextButton(
                    child: const Text('NO'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: const Text('YES'),
                    onPressed: () {
                      String shift = model.findShift(model.user.name, picked);
                      if (shift != '' && shift != 'null') {
                        model.isLoading = true;
                        model.addShift(model.user.name, picked, shift);
                        Navigator.pop(context);
                        model.isLoading = false;
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Error'),
                                content: const Text(
                                    'You do not work on the day you selected'),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text('OK'),
                                    onPressed: () => Navigator.pop(context),
                                  )
                                ],
                              );
                            });
                      }
                    },
                  )
                ],
              );
            });
      });
    }
  }

  void createShift(BuildContext context, MainModel model) {


  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? child, MainModel model) {
        List<Shift> newShifts = [];
        String shift;
        for (int i = 0; i < model.shiftPool.length; i++) {
          shift = model.findShift(model.user.name, model.shiftPool[i].date);
          if (shift == '' ||
              model.shiftPool[i].employeeName == model.user.name) {
            newShifts.add(model.shiftPool[i]);
          }
        }

        Widget content = const Center(
            child: Text('There are currently no shifts available to pick up'));
        if (model.isLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else if (newShifts.isNotEmpty) {
          content = listShifts(model, newShifts);
        }
        return Scaffold(
            appBar: AppBar(title: const Text('Shift Pool')),
            drawer: _buildDrawer(context, model),
            floatingActionButton: FloatingActionButton(
              tooltip: 'Add shift',
              child: const Icon(Icons.add),
              onPressed: () {
                if (model.user.manager) {
                } else {
                  _selectDate(context, model);
                }
              },
            ),
            body:
                RefreshIndicator(onRefresh: model.fetchShifts, child: content));
      },
    );
  }
}
