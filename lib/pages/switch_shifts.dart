import 'package:flutter/material.dart';

import '../tabs/trade_shifts.dart';
import '../tabs/pending_requests.dart';
import '../tabs/personal_shift_log.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class SwitchShiftsPage extends StatefulWidget {
  final MainModel model;
  SwitchShiftsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _SwitchShiftsPageState();
  }
}

class _SwitchShiftsPageState extends State<SwitchShiftsPage> {
  Widget _buildDrawer(BuildContext context, MainModel model) {
    return Drawer(
      child: Column(children: model.listTiles),
    );
  }

  Widget _updateTab(int index, MainModel model) {
    if (index == 0) {
      return TradeShiftsTab();
    } else if (index == 1) {
      return PendingRequestsTab();
    } else if (index == 2) {
      return PersonalShiftLogTab(widget.model);
    } else {
      return Container();
    }
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _updateTab(_currentIndex, widget.model),
      appBar: AppBar(title: Text('Change Shifts')),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.swap_horiz), title: Text('Trade')),
            BottomNavigationBarItem(
                icon: Icon(Icons.timer), title: Text('Pending Requests')),
            BottomNavigationBarItem(
                icon: Icon(Icons.update), title: Text('Personal Updates')),
          ]),
      drawer: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return _buildDrawer(context, model);
        },
      ),
    );
  }
}
