import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AnnouncementsPageListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.announcement),
      title: Text('Announcements'),
      onTap: () => Navigator.pushReplacementNamed(context, '/announcements'),
    );
  }
}

class RequestShiftChangeListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.swap_vert),
      title: Text('Change Shifts'),
      onTap: () => Navigator.pushReplacementNamed(context, '/change_shifts'),
    );
  }
}

class CreateScheduleListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.create),
      title: Text('Create Schedule'),
      onTap: () => Navigator.pushReplacementNamed(context, '/select_day'),
    );
  }
}

class ScheduleListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.calendar_today),
      title: Text('Schedule'),
      onTap: () => Navigator.pushReplacementNamed(context, '/schedule'),
    );
  }
}

class ManagerConsoleListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          leading: Icon(Icons.offline_bolt),
          title: Text('Manager Console'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/manager_console');
          },
        );
      },
    );
  }
}

class PromotionsListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListTile(
          leading: Icon(Icons.label_important),
          title: Text('Promotions'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/promotions');
            
          },
        );
      },
    );
  }
}

class AccountListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.person),
      title: Text('Account'),
      onTap: () => Navigator.pushReplacementNamed(context, '/account'),
    );
  }
}

class ShiftPoolListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.people),
      title: Text('Shift Pool'),
      onTap: () => Navigator.pushReplacementNamed(context, '/pool'),
    );
  }
}
