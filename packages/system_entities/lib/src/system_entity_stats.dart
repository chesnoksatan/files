import 'dart:io';

import 'package:entity/entity.dart';

class SystemEntityStats extends IEntityStats {
  @override
  DateTime accessed;

  @override
  DateTime changed;

  @override
  DateTime modified;

  @override
  EntityPermissions permissions;

  @override
  int size;

  SystemEntityStats({
    required this.accessed,
    required this.changed,
    required this.modified,
    required this.size,
    required this.permissions,
  });

  SystemEntityStats.fromFileStat(FileStat stat)
      : this(
          accessed: stat.accessed,
          changed: stat.changed,
          modified: stat.modified,
          size: stat.size,
          permissions: EntityPermissions(stat.mode),
        );
}
