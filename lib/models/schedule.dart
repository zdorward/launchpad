import 'package:flutter/material.dart';

class Schedule {
  final String key;
  final List<dynamic> data;
  List<Widget> widget;
  final DateTime firstDate;
  final DateTime lastDate;
  final List<dynamic> employeeNames;

  Schedule(
      {@required this.key,
      @required this.data,
      @required this.widget,
      @required this.firstDate,
      @required this.lastDate,
      @required this.employeeNames});
  Schedule.from(Schedule other)
      : key = other.key,
        data = other.data,
        widget = other.widget,
        firstDate = other.firstDate,
        lastDate = other.lastDate,
        employeeNames = other.employeeNames;
}
