import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

import '../models/update.dart';

import '../widgets/error.dart';

class PersonalShiftLogTab extends StatefulWidget {
  final MainModel model;
  PersonalShiftLogTab(this.model);

  @override
  State<StatefulWidget> createState() {
    return _PersonalShiftLogTabState();
  }
}

class _PersonalShiftLogTabState extends State<PersonalShiftLogTab> {
  @override
  initState() {
    widget.model.fetchUpdates().then((bool success) {
      widget.model.isLoading = false;
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

  List<Update> findPersonalUpdates(MainModel model) {
    List<Update> newUpdates = [];
    for (var i = 0; i < model.shiftChangeHistory.length; i++) {
      Update update =
          model.shiftChangeHistory[model.shiftChangeHistory.length - i - 1];
      if (update.employeeName1 == model.user.name ||
          update.employeeName2 == model.user.name) {
        newUpdates.add(update);
      }
    }

    return newUpdates;
  }

  Widget listUpdates(MainModel model) {
    List<Update> newUpdates = findPersonalUpdates(model);
    return ListView.builder(
      itemCount: newUpdates.length,
      itemBuilder: (BuildContext context, int index) {
        String otherEmployee;
        Update update = newUpdates[index];
        if (update.employeeName1 == model.user.name) {
          otherEmployee = update.employeeName2;
        } else {
          otherEmployee = update.employeeName1;
        }

        return Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
              ),
              title: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(text: 'You traded shifts with '),
                      TextSpan(
                        text: otherEmployee,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' on '),
                      TextSpan(
                        text: '${update.date}',
                      ),
                    ]),
              ),
              trailing: update.seen
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.check,
                      color: Colors.grey,
                    ),
            ),
            Divider()
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No updates found'));
      if (model.isLoading) {
        content = Center(child: CircularProgressIndicator());
      } else if (model.shiftChangeHistory != null &&
          model.shiftChangeHistory.length > 0) {
        content = listUpdates(model);
      }
      return RefreshIndicator(onRefresh: model.fetchUpdates, child: content);
    });
  }
}
