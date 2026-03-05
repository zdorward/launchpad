import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';
import '../widgets/error.dart';

class SchedulePage extends StatefulWidget {
  final MainModel model;
  const SchedulePage(this.model, {super.key});

  @override
  State<StatefulWidget> createState() {
    return _SchedulePageState();
  }
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  initState() {
    super.initState();
    widget.model.fetchSchedules().then((bool success) {
      if (!success && mounted) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return const ShowErrorDialogue();
            });
      }
    });
  }

  Widget _buildDrawer() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget? child, MainModel model) {
      return Drawer(
        child: Column(children: model.listTiles),
      );
    });
  }

  Widget _buildSchedule() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget? child, MainModel model) {
      Widget content = const Center(child: Text('No available schedule'));
      if (model.allSchedules.isNotEmpty) {
        content = Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background.png'),
            ),
          ),
          child: PageView.builder(
            itemCount: model.allSchedules.length,
            itemBuilder: (BuildContext context, int index) {
              return GridView.count(
                  primary: false,
                  crossAxisSpacing: 1.0,
                  mainAxisSpacing: 1.0,
                  padding: const EdgeInsets.only(top: 1.0, left: 3.0, right: 3.0),
                  childAspectRatio: 2.0,
                  crossAxisCount: 8,
                  children: model.allSchedules[index].widget);
            },
          ),
        );
      } else if (model.isLoading) {

        content = Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/background.png'),
            ),
          ),
          child: const Center(child: CircularProgressIndicator()),
        );
      }
      return content;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule'),
      ),
      drawer: _buildDrawer(),
      body: _buildSchedule(),
    );
  }
}
