import 'dart:io';

import 'package:entity/entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:system_entities/src/system_entitie_helper.dart';

import 'package:system_entities/system_entities.dart';

const List<String> _kCurrentDirectoryFileNames = [
  "system_entities_test.dart",
  "test_file.txt",
  "test_folder",
  "new_name_test_dir",
];

void main() async {
  group(
    "SystemEntities",
    () {
      final SystemEntitiesFetcherController controller =
          SystemEntitiesFetcherController(
        Directory("${Directory.current.path}/test"),
      );

      test(
        "Entities count test",
        () => expect(
          controller.entities.length,
          _kCurrentDirectoryFileNames.length,
        ),
      );

      test(
        "Fetching test",
        () {
          final List<String> currentDirectoryNamesByFetcher =
              controller.entities.map((entity) => entity.name).toList();

          for (final String currentName in _kCurrentDirectoryFileNames) {
            expect(currentDirectoryNamesByFetcher.contains(currentName), true);
          }
        },
      );

      test(
        "test_folder type is EntityType.directory",
        () {
          final IEntity testFolderEntity = controller.entities[controller
              .entities
              .indexWhere((element) => element.name == "test_folder")];
          expect(testFolderEntity.type, EntityType.directory);
          expect(testFolderEntity.isDirectory, true);
          expect(testFolderEntity.isFile, false);
        },
      );

      test(
        "test_file.txt type is EntityType.file",
        () {
          final IEntity testFileEntity = controller.entities[controller.entities
              .indexWhere((element) => element.name == "test_file.txt")];
          expect(testFileEntity.type, EntityType.file);
          expect(testFileEntity.isDirectory, false);
          expect(testFileEntity.isFile, true);
        },
      );

      test(
        "Create directory test async",
        () async {
          final SystemEntitieHelper helper = SystemEntitieHelper();

          final SystemEntity entity = await helper.create(
              "${controller.currentDir.path}/another_test_dir",
              EntityType.directory);

          expect(entity.type, EntityType.directory);
          expect(entity.name, "another_test_dir");
        },
      );

      test(
        "Remove directory test async",
        () async {
          controller.reload();

          final IEntity entity = controller.entities[controller.entities
              .indexWhere((element) => element.name == "another_test_dir")];

          await entity.delete();
        },
      );

      test(
        "Create directory test sync",
        () {
          final SystemEntitieHelper helper = SystemEntitieHelper();

          final SystemEntity entity = helper.createSync(
              "${controller.currentDir.path}/another_test_dir",
              EntityType.directory);

          expect(entity.type, EntityType.directory);
          expect(entity.name, "another_test_dir");
        },
      );

      test(
        "Remove directory test sync",
        () {
          controller.reload();

          final IEntity entity = controller.entities[controller.entities
              .indexWhere((element) => element.name == "another_test_dir")];

          entity.deleteSync();
        },
      );

      test(
        "Rename test sync",
        () {
          final IEntity entity = controller.entities[controller.entities
              .indexWhere((element) => element.name == "new_name_test_dir")];

          entity.renameSync("another_test_folder");

          expect(entity.name, "another_test_folder");
        },
      );

      test(
        "Rename test async",
        () async {
          final IEntity entity = controller.entities[controller.entities
              .indexWhere((element) => element.name == "another_test_folder")];

          await entity.rename("new_name_test_dir");

          expect(entity.name, "new_name_test_dir");
        },
      );
    },
  );
}
