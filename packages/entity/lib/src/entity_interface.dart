import 'package:entity/src/utils.dart';
import 'package:entity/src/entity_comparator.dart';
import 'package:entity/src/entity_stats.dart';
import 'package:flutter/material.dart';

enum EntityType {
  file,
  directory,
  link,
  undefined,
}

abstract class IEntity {
  String get path;
  EntityType get type;
  IEntityStats get stats;

  IconData get icon =>
      isDirectory ? Icons.folder : Utils.getIconForMimeType(mimeType);
  String get mimeType => Utils.getMimeType(path);
  String get name => Utils.getEntityName(path);

  bool get isDirectory => type == EntityType.directory;
  bool get isLink => type == EntityType.link;
  bool get isFile => type == EntityType.file;

  String? get linkTarget;

  Future<IEntity> rename(String newName);
  IEntity renameSync(String newName);

  Future<void> delete({bool recursive = false});
  void deleteSync({bool recursive = false});

  /// Compares this entity to [other].
  ///
  /// If you don't use [comparator] parameter,
  /// then sorting will be performed from A to Z by [IEntity.name]
  int compareTo(
    IEntity other, {
    EntityComparator? comparator,
  }) {
    comparator ??= EntityComparator();
    return comparator.compare(this, other);
  }

  @override
  String toString() => "Name: $name, Type: $type, Path: $path";
}
