import 'package:flutter/material.dart';

class Shift {
  final String key;
  final String employeeName;
  final DateTime date;
  final String shift;

  Shift({
    @required this.key,
    @required this.employeeName,
    @required this.date,
    @required this.shift
  });
}
