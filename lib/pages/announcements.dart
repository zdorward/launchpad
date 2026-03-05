import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AnnouncementsPage extends StatelessWidget {
  const AnnouncementsPage({super.key});

  Widget _buildDrawer(BuildContext context, MainModel model) {
    return Drawer(
      child: Column(children: model.listTiles),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Announcements'),
      ),
      drawer: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget? child, MainModel model) {
          return _buildDrawer(context, model);
        },
      ),
      body: const Center(
        child: Text('Coming Soon'),
      ),
    );
  }
}
