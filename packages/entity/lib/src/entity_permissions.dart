import 'constants.dart';

/// https://en.wikipedia.org/wiki/File-system_permissions#Numeric_notation
class EntityPermissions {
  final int _mode;

  const EntityPermissions(int mode) : _mode = mode;

  int get mode => _mode;
  int get permissions => mode & 0xFFF;
  int get ownerMode => (permissions >> 6) & 0x7;
  int get groupMode => (permissions >> 3) & 0x7;
  int get otherMode => permissions & 0x7;

  bool get isValid => mode >= 0;
  bool get isNotValid => mode < 0;

  String get modeString {
    if (isNotValid) return invalidPermission;

    final List<String> result = List<String>.empty(growable: true);

    if ((permissions & 0x800) != 0) result.add(suid);
    if ((permissions & 0x400) != 0) result.add(guid);
    if ((permissions & 0x200) != 0) result.add(sticky);

    result
      ..add(codes[ownerMode])
      ..add(codes[groupMode])
      ..add(codes[otherMode]);

    return result.join();
  }

  String get ownerModeString =>
      isValid ? codesHumanReadableString[ownerMode] : invalidPermission;

  String get groupModeString =>
      isValid ? codesHumanReadableString[groupMode] : invalidPermission;

  String get otherModeString =>
      isValid ? codesHumanReadableString[otherMode] : invalidPermission;
}
