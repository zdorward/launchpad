import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class AnnouncementsPage extends StatelessWidget {
  Widget _buildDrawer(BuildContext context, MainModel model) {
    return Drawer(
      child: Column(children: model.listTiles),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Announcements'),
      ),
      drawer: ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
          return _buildDrawer(context, model);
        },
      ),
      body: Center(
        child: Text('Coming Soon'),
      ),
    );
  }
}
