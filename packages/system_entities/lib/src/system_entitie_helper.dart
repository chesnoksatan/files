import 'dart:io';

import 'package:entity/entity.dart';
import 'package:system_entities/src/system_entity.dart';
import 'package:system_entities/src/system_entity_stats.dart';

class SystemEntityHelper extends IEntityHelper {
  @override
  Future<void> paste(String dest) async {
    if (canPaste()) {
      currentOperation = null;
      for (final IEntity entity in clipboard) {
        final String newPath = dest + entity.name;

        switch (entity.type) {
          case EntityType.directory:
            createDir(newPath);
            break;
          case EntityType.file:
            createFile(newPath);
            break;
          case EntityType.link:
            createLink(newPath, entity.linkTarget!);
            break;
          default:
        }

        if (currentOperation == Operation.cut) entity.delete();
      }
    }
  }

  @override
  void pasteSync(String dest) {
    if (canPaste()) {
      currentOperation = null;
      for (final IEntity entity in clipboard) {
        final String newPath = dest + entity.name;

        switch (entity.type) {
          case EntityType.directory:
            createDirSync(newPath);
            break;
          case EntityType.file:
            createFileSync(newPath);
            break;
          case EntityType.link:
            createLinkSync(newPath, entity.linkTarget!);
            break;
          default:
        }

        if (currentOperation == Operation.cut) entity.deleteSync();
      }
    }
  }

  @override
  Future<SystemEntity> createDir(String path) async {
    return SystemEntity(
      entity: await Directory(path).create(),
      stats: SystemEntityStats.fromFileStat(
        await FileStat.stat(path),
      ),
    );
  }

  @override
  SystemEntity createDirSync(String path) {
    Directory(path).createSync();
    return SystemEntity(
      entity: Directory(path),
      stats: SystemEntityStats.fromFileStat(
        FileStat.statSync(path),
      ),
    );
  }

  @override
  Future<SystemEntity> createFile(String path) async {
    return SystemEntity(
      entity: await File(path).create(),
      stats: SystemEntityStats.fromFileStat(
        await FileStat.stat(path),
      ),
    );
  }

  @override
  SystemEntity createFileSync(String path) {
    File(path).createSync();
    return SystemEntity(
      entity: File(path),
      stats: SystemEntityStats.fromFileStat(
        FileStat.statSync(path),
      ),
    );
  }

  @override
  Future<SystemEntity> createLink(String path, String target) async {
    return SystemEntity(
      entity: await Link(path).create(target),
      stats: SystemEntityStats.fromFileStat(
        await FileStat.stat(path),
      ),
    );
  }

  @override
  SystemEntity createLinkSync(String path, String target) {
    Link(path).createSync(target);
    return SystemEntity(
      entity: Link(path),
      stats: SystemEntityStats.fromFileStat(
        FileStat.statSync(path),
      ),
    );
  }
}
