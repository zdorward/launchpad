import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

import '../models/schedule.dart';
import '../widgets/error.dart';

class ManageSchedulesTab extends StatefulWidget {
  const ManageSchedulesTab({super.key});

  @override
  State<ManageSchedulesTab> createState() => _ManageSchedulesTabState();
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
  late Schedule schedule;

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
                    title: const Text('Confirm Deletion'),
                    content:
                        const Text('Are you sure you want to delete this schedule?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('NO'),
                        onPressed: () {
                          setState(() {
                            model.reinsertSchedule(schedule, index);
                          });

                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('YES'),
                        onPressed: () {
                          Navigator.pop(context);
                          model.deleteSchedule(index).then((bool success) {
                            if (!mounted) return;
                            if (!success) {
                              model.reinsertSchedule(schedule, index);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ShowErrorDialogue();
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
              ),
              const Divider()
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
      builder: (BuildContext context, Widget? child, MainModel model) {
        Widget content = const Center(child: Text('No schedules found'));
        if (model.isLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else if (model.allSchedules.isNotEmpty) {
          content = listSchedules(model);
        }
        return RefreshIndicator(
            onRefresh: model.fetchSchedules, child: content);
      },
    );
  }
}
