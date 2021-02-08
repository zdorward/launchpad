import 'package:flutter/material.dart';

class Update {
  final String key;
  final String employeeName1;
  final String employeeName2;
  final String date;
  bool seen;

  Update({
    @required this.key,
    @required this.employeeName1,
    @required this.employeeName2,
    @required this.date,
    @required this.seen,
  });
}
