import 'dart:io';

import 'package:entity/entity.dart';
import 'package:system_entities/src/system_entity.dart';
import 'package:system_entities/src/system_entity_stats.dart';

class SystemEntitieHelper extends IEntityHelper {
  @override
  Future<void> paste(String dest) {
    // TODO: implement paste
    throw UnimplementedError();
  }

  @override
  void pasteSync(String dest) {
    // TODO: implement pasteSync
  }

  @override
  Future<SystemEntity> create(String path, EntityType type) async {
    late final FileSystemEntity newEntity;

    if (type == EntityType.directory) {
      newEntity = await Directory(path).create();
    } else if (type == EntityType.file) {
      newEntity = await File(path).create();
    } else if (type == EntityType.link) {
    } else {
      throw Exception("Cannot create SystemEntity");
    }

    return SystemEntity(
      entity: newEntity,
      stats: SystemEntityStats.fromFileStat(
        await FileStat.stat(newEntity.path),
      ),
    );
  }

  @override
  SystemEntity createSync(String path, EntityType type) {
    late final FileSystemEntity newEntity;

    if (type == EntityType.directory) {
      Directory(path).createSync();
      newEntity = Directory(path);
    } else if (type == EntityType.file) {
      File(path).createSync();
      newEntity = File(path);
    } else if (type == EntityType.link) {
    } else {
      throw Exception("Cannot create SystemEntity");
    }

    return SystemEntity(
      entity: newEntity,
      stats: SystemEntityStats.fromFileStat(
        FileStat.statSync(newEntity.path),
      ),
    );
  }
}
