import 'dart:io';

import 'package:entity/entity.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:system_entities/system_entities.dart';

const List<String> _currentDirectoryEntities = [
  "test_folder",
  ".test_hidden_files.txt",
  "system_entities_test.dart",
  "test_file.txt",
  "test_json_file.json",
  "test_link.txt",
  "test_md_file.md",
];

const List<String> _currentDirectoryEntitiesWithoutHidden = [
  "test_folder",
  "system_entities_test.dart",
  "test_file.txt",
  "test_json_file.json",
  "test_link.txt",
  "test_md_file.md",
];

const List<String> _testFolderEntities = [
  "test_file.txt",
  ".test_hidden_files.txt",
];

const Map<String, EntityType> _currentDirectoryEntitiesTypes = {
  "test_folder": EntityType.directory,
  ".test_hidden_files.txt": EntityType.file,
  "system_entities_test.dart": EntityType.file,
  "test_file.txt": EntityType.file,
  "test_json_file.json": EntityType.file,
  "test_link.txt": EntityType.link,
  "test_md_file.md": EntityType.file,
};

const Map<String, String?> _currentDirectoryEntitiesMimeTypes = {
  "test_folder": null,
  "test_file.txt": "text/plain",
  "test_md_file.md": null,
  "test_json_file.json": "application/json",
  "test_link.txt": "text/plain",
};

const Map<String, String?> _currentDirectoryEntitiesExtensions = {
  "test_folder": null,
  "system_entities_test.dart": "dart",
  "test_file.txt": "txt",
  "test_json_file.json": "json",
  "test_md_file.md": "md",
};

const Map<String, int> _currentDirectorySizes = {
  "test_file.txt": 23,
  "test_json_file.json": 3,
  "test_link.txt": 23,
  "test_md_file.md": 15,
};

const Map<String, String> _currentDirectoryPermissions = {
  "test_folder": "rwxrwxr-x",
  "system_entities_test.dart": "rw-rw-r--",
  "test_file.txt": "rw-rw-r--",
  "test_json_file.json": "rw-rw-r--",
  "test_link.txt": "rw-rw-r--",
  "test_md_file.md": "rw-rw-r--",
};

void main() async {
  group(
    "Fetch testing",
    () {
      final SystemEntitiesFetcherController controller =
          SystemEntitiesFetcherController(
        Directory("${Directory.current.path}/test"),
      );

      test(
        "Current directory without hidden files test",
        () async {
          controller.showHidden = false;
          await Future.delayed(const Duration(milliseconds: 50));

          expect(controller.entities, isNotEmpty);
          expect(
            _currentDirectoryEntitiesWithoutHidden,
            orderedEquals(controller.entities.map((e) => e.name)),
          );
        },
      );

      test(
        "Current directory test",
        () async {
          controller.showHidden = true;
          await Future.delayed(const Duration(milliseconds: 50));

          expect(controller.entities, isNotEmpty);
          expect(
            _currentDirectoryEntities,
            orderedEquals(controller.entities.map((e) => e.name)),
          );
        },
      );

      test(
        "Types test",
        () {
          for (final key in _currentDirectoryEntitiesTypes.keys) {
            final IEntity? entity = controller.getEntityByName(key);
            expect(entity, isNotNull);
            if (entity != null) {
              expect(entity.type, _currentDirectoryEntitiesTypes[key]);
            }
          }
        },
      );

      test(
        "MimeTypes test",
        () {
          for (final key in _currentDirectoryEntitiesMimeTypes.keys) {
            final IEntity? entity = controller.getEntityByName(key);
            expect(entity, isNotNull);
            if (entity != null) {
              expect(entity.mimeType, _currentDirectoryEntitiesMimeTypes[key]);
            }
          }
        },
      );

      test(
        "Extension test",
        () {
          for (final key in _currentDirectoryEntitiesExtensions.keys) {
            final IEntity? entity = controller.getEntityByName(key);
            expect(entity, isNotNull);
            if (entity != null) {
              expect(
                entity.extension,
                _currentDirectoryEntitiesExtensions[key],
              );
            }
          }
        },
      );

      test(
        "Stats test",
        () {
          for (final key in _currentDirectorySizes.keys) {
            final IEntity? entity = controller.getEntityByName(key);
            expect(entity, isNotNull);
            if (entity != null) {
              expect(
                entity.stats.size,
                _currentDirectorySizes[key],
              );
            }
          }
        },
      );

      test(
        "Permissions test",
        () {
          for (final key in _currentDirectoryPermissions.keys) {
            final IEntity? entity = controller.getEntityByName(key);
            expect(entity, isNotNull);
            if (entity != null) {
              expect(
                entity.stats.permissions.modeString,
                _currentDirectoryPermissions[key],
              );
            }
          }
        },
      );
    },
  );

  // group(
  //   "Base entities operation testing\n",
  //   () {
  //     final SystemEntitiesFetcherController controller =
  //         SystemEntitiesFetcherController(
  //       Directory("${Directory.current.path}/test"),
  //     );

  //     group(
  //       "\tCreate test\n",
  //       () {
  //         final SystemEntityHelper helper = SystemEntityHelper();

  //         test(
  //           "\t\tCreate directory test async",
  //           () async {
  //             final SystemEntity entity = await helper.createDir(
  //               "${controller.currentDir.path}/another_test_dir",
  //             );

  //             expect(entity.type, EntityType.directory);
  //             expect(entity.name, "another_test_dir");
  //             expect(entity.extension, isNull);
  //             expect(entity.mimeType, isNull);
  //             expect(controller.entities.contains(entity), true);
  //           },
  //         );

  //         test(
  //           "\t\tCreate plain text file test async",
  //           () async {
  //             final SystemEntity entity = await helper.createFile(
  //               "${controller.currentDir.path}/another_test_file.txt",
  //             );

  //             expect(entity.type, EntityType.file);
  //             expect(entity.name, "another_test_file.txt");
  //             expect(entity.extension, "txt");
  //             expect(entity.mimeType, "text/plain");
  //             expect(controller.entities.contains(entity), true);
  //           },
  //         );

  //         test(
  //           "\t\tCreate directory test sync",
  //           () {
  //             final SystemEntity entity = helper.createDirSync(
  //               "${controller.currentDir.path}/another_test_dir",
  //             );

  //             expect(entity.type, EntityType.directory);
  //             expect(entity.name, "another_test_dir");
  //             expect(entity.extension, isNull);
  //             expect(entity.mimeType, isNull);
  //             expect(controller.entities.contains(entity), true);
  //           },
  //         );

  //         test(
  //           "\t\tCreate plain text file test sync",
  //           () {
  //             final SystemEntity entity = helper.createFileSync(
  //               "${controller.currentDir.path}/another_test_file.txt",
  //             );

  //             expect(entity.type, EntityType.file);
  //             expect(entity.name, "another_test_file.txt");
  //             expect(entity.extension, "txt");
  //             expect(entity.mimeType, "text/plain");
  //             expect(controller.entities.contains(entity), true);
  //           },
  //         );
  //       },
  //     );
  //     group(
  //       "\tRename test\n",
  //       () {
  //         test(
  //           "\t\tRename directory test async",
  //           () async {
  //             final IEntity? entity =
  //                 controller.getEntityByName("another_test_dir");

  //             expect(entity, isNotNull);

  //             if (entity != null) {
  //               expect(entity.isDirectory, true);
  //               expect(entity.name, "another_test_dir");

  //               await entity.rename("new_name_for_another_test_dir");

  //               expect(entity.name, "new_name_for_another_test_dir");
  //             }

  //             expect(
  //               controller.getEntityByName("new_name_for_another_test_dir"),
  //               isNotNull,
  //             );
  //           },
  //         );

  //         test(
  //           "\t\tRename directory test sync",
  //           () {
  //             final IEntity? entity =
  //                 controller.getEntityByName("new_name_for_another_test_dir");

  //             expect(entity, isNotNull);

  //             if (entity != null) {
  //               expect(entity.isDirectory, true);
  //               expect(entity.name, "new_name_for_another_test_dir");

  //               entity.renameSync("another_test_dir");

  //               expect(entity.name, "another_test_dir");
  //             }

  //             expect(
  //               controller.getEntityByName("another_test_dir"),
  //               isNotNull,
  //             );
  //           },
  //         );
  //       },
  //     );

  //     group(
  //       "Copy test",
  //       () {
  //         final IEntity? entity = controller.getEntityByName("test_file.txt");

  //         expect(entity, isNotNull);
  //       },
  //     );

  //     group(
  //       "Cut test",
  //       () {},
  //     );

  //     group(
  //       "Delete test",
  //       () {},
  //     );
  //   },
  // );
}
