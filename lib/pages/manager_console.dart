import 'package:flutter/material.dart';

import '../tabs/manage_employees.dart';
import '../tabs/manage_schedules.dart';
import '../tabs/shift_log.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ManagerConsole extends StatefulWidget {
  final MainModel model;
  const ManagerConsole(this.model, {super.key});

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
      return const ManageSchedulesTab();
    } else if (index == 1) {
      return const ManageEmployeesTab();
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
      appBar: AppBar(title: const Text('Manager Console')),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today), label: 'Schedules'),
            BottomNavigationBarItem(
                icon: Icon(Icons.people), label: 'Employees'),
            BottomNavigationBarItem(
                icon: Icon(Icons.update), label: 'Recent Updates'),
          ]),
      drawer: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget? child, MainModel model) {
          return _buildDrawer(context, model);
        },
      ),
    );
  }
}
