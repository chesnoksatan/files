import 'package:entity/src/entity_permissions.dart';

abstract class IEntityStats {
  int get size;

  DateTime get changed;
  DateTime get modified;
  DateTime get accessed;

  EntityPermissions get permissions;

  @override
  String toString() =>
      "Size: $size, Changed date: $changed, Permissions: ${permissions.modeString}";
}
