import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';

import '../models/update.dart';

import '../widgets/error.dart';

class ShiftLogTab extends StatefulWidget {
  final MainModel model;
  const ShiftLogTab(this.model, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _ShiftLogTabState();
  }
}

class _ShiftLogTabState extends State<ShiftLogTab> {
  @override
  initState() {
    super.initState();
    widget.model.fetchUpdates().then((bool success) {
      widget.model.isLoading = false;
      if (!success && mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const ShowErrorDialogue();
            });
      }
    });
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
                        text: update.employeeName1,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' traded shifts with '),
                      TextSpan(
                        text: update.employeeName2,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const TextSpan(text: ' on '),
                      TextSpan(
                        text: update.date,
                      ),
                    ]),
              ),
              trailing: update.seen
                  ? const Icon(
                      Icons.check,
                      color: Colors.grey,
                    )
                  : const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
            ),
            const Divider()
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget? child, MainModel model) {

      Widget content = const Center(child: Text('No updates found'));
      if (model.isLoading) {
        content = const Center(child: CircularProgressIndicator());
      } else if (model.shiftChangeHistory.isNotEmpty) {
        content = listUpdates(model);
      }
      return RefreshIndicator(onRefresh: model.fetchUpdates, child: content);
    });
  }
}
