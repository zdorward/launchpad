import 'package:flutter/material.dart';

class Promotion {
  final String key;
  final String name;
  final String description;

  Promotion({
    @required this.key,
    @required this.name,
    @required this.description,
  });
  Promotion.from(Promotion other)
      : key = other.key,
        name = other.name,
        description = other.description;
}
