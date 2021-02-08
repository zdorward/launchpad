import 'package:flutter/material.dart';

import '../tabs/manage_employees.dart';
import '../tabs/manage_schedules.dart';
import '../tabs/shift_log.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ManagerConsole extends StatefulWidget {
  final MainModel model;
  ManagerConsole(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ManagerConsoleState();
  }
}

class _ManagerConsoleState extends State<ManagerConsole> {
  Widget _buildDrawer(BuildContext context, MainModel model) {
    return Drawer(
      child: Column(children: model.listTiles),
    );
  }

  Widget _updateTab(int index) {
    if (index == 0) {
      return ManageSchedulesTab();
    } else if (index == 1) {
      return ManageEmployeesTab();
    } else if (index == 2) {
      return ShiftLogTab(widget.model);
    }
    {
      return Container();
    }
  }

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _updateTab(_currentIndex),
      appBar: AppBar(title: Text('Manager Console')),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), title: Text('Schedules')),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), title: Text('Employees')),
            BottomNavigationBarItem(
                icon: Icon(Icons.update), title: Text('Recent Updates')),
          ]),
      drawer: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return _buildDrawer(context, model);
        },
      ),
    );
  }
}
