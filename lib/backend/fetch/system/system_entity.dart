import 'dart:io';

import 'package:files/backend/fetch/interfaces/entity.dart';
import 'package:files/backend/utils.dart';
import 'package:flutter/material.dart';

class SystemEntity extends IEntity {
  FileSystemEntity _entity;

  SystemEntity(FileSystemEntity entity) : _entity = entity;

  @override
  String toString() => _entity.path;

  @override
  String get name => Utils.getEntityName(_entity.path);

  @override
  IconData get icon =>
      isDirectory ? Icons.folder : Utils.iconForPath(_entity.path);

  @override
  bool get isDirectory => _entity is Directory;

  @override
  String get path => _entity.path;
}
