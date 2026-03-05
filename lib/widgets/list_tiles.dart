import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AnnouncementsPageListTile extends StatelessWidget {
  const AnnouncementsPageListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.announcement),
      title: const Text('Announcements'),
      onTap: () => Navigator.pushReplacementNamed(context, '/announcements'),
    );
  }
}

class RequestShiftChangeListTile extends StatelessWidget {
  const RequestShiftChangeListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.swap_vert),
      title: const Text('Change Shifts'),
      onTap: () => Navigator.pushReplacementNamed(context, '/change_shifts'),
    );
  }
}

class CreateScheduleListTile extends StatelessWidget {
  const CreateScheduleListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.create),
      title: const Text('Create Schedule'),
      onTap: () => Navigator.pushReplacementNamed(context, '/select_day'),
    );
  }
}

class ScheduleListTile extends StatelessWidget {
  const ScheduleListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.calendar_today),
      title: const Text('Schedule'),
      onTap: () => Navigator.pushReplacementNamed(context, '/schedule'),
    );
  }
}

class ManagerConsoleListTile extends StatelessWidget {
  const ManagerConsoleListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? child, MainModel model) {
        return ListTile(
          leading: const Icon(Icons.offline_bolt),
          title: const Text('Manager Console'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/manager_console');
          },
        );
      },
    );
  }
}

class PromotionsListTile extends StatelessWidget {
  const PromotionsListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? child, MainModel model) {
        return ListTile(
          leading: const Icon(Icons.label_important),
          title: const Text('Promotions'),
          onTap: () {
            Navigator.pushReplacementNamed(context, '/promotions');

          },
        );
      },
    );
  }
}

class AccountListTile extends StatelessWidget {
  const AccountListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: const Text('Account'),
      onTap: () => Navigator.pushReplacementNamed(context, '/account'),
    );
  }
}

class ShiftPoolListTile extends StatelessWidget {
  const ShiftPoolListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.people),
      title: const Text('Shift Pool'),
      onTap: () => Navigator.pushReplacementNamed(context, '/pool'),
    );
  }
}
