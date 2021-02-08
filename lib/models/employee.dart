import 'package:flutter/material.dart';

class Employee {
  final String key;
  final String name;
  final int id;
  final String pin;
  final bool manager;
  List<dynamic> requests;
  bool loggedIn;

  Employee(
      {@required this.key,
      @required this.name,
      @required this.id,
      @required this.pin,
      @required this.manager,
      @required this.requests,
      @required this.loggedIn
      });

  Employee.from(Employee other)
      : key = other.key,
        name = other.name,
        id = other.id,
        pin = other.pin,
        manager = other.manager;
}
