import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../widgets/error.dart';

class PendingRequestsTab extends StatefulWidget {
  @override
  _PendingRequestsTabState createState() => new _PendingRequestsTabState();
}

class _PendingRequestsTabState extends State<PendingRequestsTab> {
  Widget listRequests(MainModel model, List<dynamic> requests) {
    return ListView.builder(
      itemCount: requests.length,
      itemBuilder: (BuildContext context, int index) {
        return Column(
          children: <Widget>[
            ListTile(
              title: Text(requests[index]['name']),
              subtitle: Text(
                  '${DateTime.parse(requests[index]['date']).month}/${DateTime.parse(requests[index]['date']).day}/${DateTime.parse(requests[index]['date']).year}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  RaisedButton(
                    child: Text('Decline'),
                    color: Colors.red.withOpacity(0.9),
                    onPressed: () {
                      model.isLoading = true;
                      model.deleteRequest(index).then((bool success) {
                        //setState(() {});
                        model.isLoading = false;
                        if (!success) {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ShowErrorDialogue();
                              });
                        }
                      });
                    },
                  ),
                  SizedBox(width: 10.0),
                  RaisedButton(
                    child: Text('Accept'),
                    color: Colors.green.withOpacity(0.9),
                    onPressed: () {
                      DateTime date =
                          DateTime.parse(model.user.requests[index]['date']);
                      String employeeName = model.user.requests[index]['name'];
                      if (!validate(model, employeeName, date)) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'It looks like the data in this request is no longer valid. Press "Okay" to delete this request.'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () {
                                      model.deleteRequest(index);
                                      Navigator.pop(context);
                                    },
                                    child: Text('Okay'),
                                  )
                                ],
                              );
                            });
                      } else {
                        model
                            .tradeShifts(date, employeeName)
                            .then((bool success) {
                          if (!success) {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowErrorDialogue();
                                });
                          } else {
                            String dateString =
                                '${date.month}/${date.day}/${date.year}';
                            model.addUpdate(model.user.name, employeeName,
                                dateString, context);
                            model.deleteRequest(index);
                          }
                        });
                      }
                    },
                  )
                ],
              ),
            ),
            Divider()
          ],
        );
      },
    );
  }

  bool validate(MainModel model, name, date) {
    bool test1 = false;
    bool test2 = false;
    if (name == null || name == model.user.name) {
      return false;
    }
    if (model.allSchedules.length <= 0) {
      return false;
    }

    for (var i = 0; i < model.allSchedules.length; i++) {
      DateTime compareDate = date.subtract(Duration(days: date.weekday - 1));
      if ((compareDate.year == model.allSchedules[i].firstDate.year) &&
          ((compareDate.month == model.allSchedules[i].firstDate.month)) &&
          (compareDate.day == model.allSchedules[i].firstDate.day)) {
        for (int j = 0; j < model.allSchedules[i].employeeNames.length; j++) {
          if (name == model.allSchedules[i].employeeNames[j]) {
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
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      List<dynamic> requests = model.user.requests;

      Widget content = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text('No shift requests found'),
          ),
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () => model.updateUser(model.userIndex)),
        ],
      );

      if (model.isLoading) {
        content = Container(child: Center(child: CircularProgressIndicator()));
      } else if (requests != null && requests.length > 0) {
        content = listRequests(model, requests);
      }
      return RefreshIndicator(
          onRefresh: () => model.updateUser(model.userIndex), child: content);
    });
  }
}
