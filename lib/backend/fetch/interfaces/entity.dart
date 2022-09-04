import 'package:flutter/material.dart';

abstract class IEntity {
//   String path;
//   EntityStats stats;
//   EntityType type;

  String get name;
  IconData get icon;

  bool get isDirectory;

  String get path;
}
