import 'dart:io';

import 'package:entity/entity.dart';
import 'package:system_entities/src/system_entity_stats.dart';

class SystemEntity extends IEntity {
  final FileSystemEntity _entity;

  @override
  final SystemEntityStats stats;

  SystemEntity({
    required FileSystemEntity entity,
    required this.stats,
  }) : _entity = entity;

  @override
  String get path => _entity.path;

  @override
  EntityType get type {
    final FileSystemEntityType systemType = FileSystemEntity.typeSync(path);

    if (systemType == FileSystemEntityType.file) {
      return EntityType.file;
    }

    if (systemType == FileSystemEntityType.directory) {
      return EntityType.directory;
    }

    if (systemType == FileSystemEntityType.link) {
      return EntityType.link;
    }

    return EntityType.undefined;
  }
}
