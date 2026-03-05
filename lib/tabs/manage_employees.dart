import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

import '../models/employee.dart';
import '../widgets/error.dart';

class ManageEmployeesTab extends StatefulWidget {
  const ManageEmployeesTab({super.key});

  @override
  State<ManageEmployeesTab> createState() => _ManageEmployeesTabState();
}

class _ManageEmployeesTabState extends State<ManageEmployeesTab> {
  late Employee employee;

  Widget listEmployees(MainModel model) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: ObjectKey(model.employees[index]),
          onDismissed: (DismissDirection direction) {
            employee = model.employees[index];
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Deletion'),
                    content: Text('Are you sure you want to delete ${employee.name}?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('NO'),
                        onPressed: () {
                          setState(() {
                            model.reinsertEmployee(employee, index);
                          });

                          Navigator.pop(context);
                        },
                      ),
                      TextButton(
                        child: const Text('YES'),
                        onPressed: () {
                          Navigator.pop(context);
                          model
                              .deleteEmployee(index, context)
                              .then((bool success) {
                            if (!mounted) return;
                            if (success) {
                            } else {
                              model.reinsertEmployee(employee, index);
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return const ShowErrorDialogue();
                                  });
                            }
                          });
                        },
                      )
                    ],
                  );
                });
          },
          background: Container(color: Colors.red),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(

                  child: Text(model.employees[index].name.substring(0, 1)),
                ),
                title: Text(model.employees[index].name),
                subtitle: Text(model.employees[index].id.toString()),

              ),
              const Divider(),
            ],
          ),
        );
      },
      itemCount: model.employees.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget? child, MainModel model) {
        Widget content = const Center(child: Text('No employees found'));
        if (model.isLoading) {
          content = const Center(child: CircularProgressIndicator());
        } else if (model.employees.isNotEmpty) {
          content = listEmployees(model);
        }
        return RefreshIndicator(
            onRefresh: model.fetchEmployees, child: content);
      },
    );
  }
}
