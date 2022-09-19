import 'dart:io';

import 'package:entity/entity.dart';
import 'package:system_entities/src/system_entity_stats.dart';

class SystemEntity extends IEntity {
  FileSystemEntity _entity;

  @override
  SystemEntityStats stats;

  SystemEntity({
    required FileSystemEntity entity,
    required this.stats,
  }) : _entity = entity;

  @override
  String get path => _entity.path;

  @override
  EntityType get type {
    final FileSystemEntityType systemType =
        FileSystemEntity.typeSync(path, followLinks: false);

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

  @override
  Future<void> delete({bool recursive = false}) async {
    _entity.delete(recursive: recursive);
  }

  @override
  void deleteSync({bool recursive = false}) {
    _entity.deleteSync(recursive: recursive);
  }

  @override
  Future<SystemEntity> rename(String newName) async {
    final String newPath = path.replaceRange(
      path.lastIndexOf(Platform.pathSeparator) + 1,
      null,
      newName,
    );

    _entity = await _entity.rename(newPath);

    return this;
  }

  @override
  SystemEntity renameSync(String newName) {
    final String newPath = path.replaceRange(
      path.lastIndexOf(Platform.pathSeparator) + 1,
      null,
      newName,
    );

    _entity = _entity.renameSync(newPath);

    return this;
  }

  @override
  String? get linkTarget {
    if (isLink) return (_entity as Link).targetSync();
    return null;
  }
}
