import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

import '../models/schedule.dart';
import '../widgets/error.dart';

class ManageSchedulesTab extends StatefulWidget {
  @override
  _ManageSchedulesTabState createState() => _ManageSchedulesTabState();
}

class _ManageSchedulesTabState extends State<ManageSchedulesTab> {
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  Schedule schedule;

  Widget listSchedules(MainModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        DateTime first = model.allSchedules[index].firstDate;
        DateTime last = model.allSchedules[index].lastDate;
        return Dismissible(
          key: ObjectKey(model.allSchedules[index]),
          onDismissed: (DismissDirection direction) {
            schedule = model.allSchedules[index];
            showDialog(
              barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Confirm Deletion'),
                    content:
                        Text('Are you sure you want to delete this schedule?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('NO'),
                        onPressed: () {
                          setState(() {
                            model.reinsertSchedule(schedule, index);
                          });

                          Navigator.pop(context);
                        },
                      ),
                      FlatButton(
                        child: Text('YES'),
                        onPressed: () {
                          Navigator.pop(context);
                          model.deleteSchedule(index).then((bool success) {
                            if (!success) {
                              model.reinsertSchedule(schedule, index);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return ShowErrorDialogue();
                                  });
                            }
                          });
                        },
                      )
                    ],
                  );
                });
          },
          background: Container(color: Colors.red),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Text((index + 1).toString()),
                ),
                title: Text(
                    '${months[first.month - 1]} ${first.day} - ${months[last.month - 1]} ${last.day}'),
                subtitle: Text(
                    '${first.month}/${first.day}/${first.year} - ${last.month}/${last.day}/${last.year}'),
                // trailing: IconButton(
                //   onPressed: () {},
                //   icon: Icon(
                //     Icons.info,
                //   ),
                // ),
              ),
              Divider()
            ],
          ),
        );
      },
      itemCount: model.allSchedules.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        Widget content = Center(child: Text('No schedules found'));
        if (model.isLoading) {
          content = Center(child: CircularProgressIndicator());
        } else if (model.allSchedules != null &&
            model.allSchedules.length > 0) {
          content = listSchedules(model);
        }
        return RefreshIndicator(
            onRefresh: model.fetchSchedules, child: content);
      },
    );
  }
}
