import 'package:entity/src/entity_permissions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:entity/entity.dart';

void checkPermission({
  required EntityPermissions permission,
  required int expectedMode,
  required String expectedModeString,
  required String expectedOwnerModeString,
  required String expectedGroupModeString,
  required String expectedOtherModeString,
}) {
  expect(permission.mode, expectedMode);
  expect(permission.modeString, expectedModeString);
  expect(permission.ownerModeString, expectedOwnerModeString);
  expect(permission.groupModeString, expectedGroupModeString);
  expect(permission.otherModeString, expectedOtherModeString);
}

void main() {
  test('Zero permission test', () {
    const EntityPermissions permission = EntityPermissions(0);

    checkPermission(
      permission: permission,
      expectedMode: 0,
      expectedModeString: "---------",
      expectedOwnerModeString: "None",
      expectedGroupModeString: "None",
      expectedOtherModeString: "None",
    );
  });

  test('Negative permissions test', () {
    const EntityPermissions permission = EntityPermissions(-1);

    checkPermission(
      permission: permission,
      expectedMode: -1,
      expectedModeString: "Permission is invalid",
      expectedOwnerModeString: "Permission is invalid",
      expectedGroupModeString: "Permission is invalid",
      expectedOtherModeString: "Permission is invalid",
    );
  });

  test('33204 (664) permission test', () {
    const EntityPermissions permission = EntityPermissions(33204);

    checkPermission(
      permission: permission,
      expectedMode: 33204,
      expectedModeString: "rw-rw-r--",
      expectedOwnerModeString: "Read and write",
      expectedGroupModeString: "Read and write",
      expectedOtherModeString: "Read-only",
    );
  });

  test('33277 (775) permission test', () {
    const EntityPermissions permission = EntityPermissions(33277);

    checkPermission(
      permission: permission,
      expectedMode: 33277,
      expectedModeString: "rwxrwxr-x",
      expectedOwnerModeString: "Read, write and execute",
      expectedGroupModeString: "Read, write and execute",
      expectedOtherModeString: "Read and execute",
    );
  });
}
