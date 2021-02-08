import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/error.dart';

class SchedulePage extends StatefulWidget {
  final MainModel model;
  SchedulePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _SchedulePageState();
  }
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  initState() {
    widget.model.fetchSchedules().then((bool success) {
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

  Widget _buildDrawer() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Drawer(
        child: Column(children: model.listTiles),
      );
    });
  }

  Widget _buildSchedule() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No available schedule'));
      if (model.allSchedules.isNotEmpty) {
        content = Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background.png'),
              // colorFilter: ColorFilter.mode(
              //     Colors.black.withOpacity(0.9), BlendMode.dstATop),
            ),
          ),
          child: PageView.builder(
            itemCount: model.allSchedules.length,
            itemBuilder: (BuildContext context, int index) {
              return GridView.count(
                  primary: false,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  padding: EdgeInsets.only(top: 1.0, left: 3.0, right: 3.0),
                  childAspectRatio: 2.0,
                  crossAxisCount: 8,
                  children: model.allSchedules[index].widget);
            },
          ),
        );
      } else if (model.isLoading) {
        
        content = Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background.png'),
            ),
          ),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Schedule'),
      ),
      drawer: _buildDrawer(),
      body: _buildSchedule(),
    );
  }
}
