import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

import '../models/update.dart';

import '../widgets/error.dart';

class ShiftLogTab extends StatefulWidget {
  final MainModel model;
  ShiftLogTab(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ShiftLogTabState();
  }
}

class _ShiftLogTabState extends State<ShiftLogTab> {
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

  Widget listUpdates(MainModel model) {
    return ListView.builder(
      itemCount: model.shiftChangeHistory.length,
      itemBuilder: (BuildContext context, int index) {
        Update update = model
            .shiftChangeHistory[model.shiftChangeHistory.length - index - 1];

        return Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                if (!update.seen) {
                  model.updateUpdates(
                      model.shiftChangeHistory.length - index - 1);
                }
              },
              leading: Icon(
                Icons.arrow_forward,
                color: Theme.of(context).primaryColor,
              ),
              title: RichText(
                text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: '${update.employeeName1}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' traded shifts with '),
                      TextSpan(
                        text: '${update.employeeName2}',
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
                      color: Colors.grey,
                    )
                  : Icon(
                      Icons.check,
                      color: Colors.green,
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
