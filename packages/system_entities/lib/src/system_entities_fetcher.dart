import 'dart:async';
import 'dart:io';

import 'package:fetcher_api/fetcher_api.dart';
import 'package:system_entities/src/system_entity.dart';
import 'package:system_entities/src/system_entity_stats.dart';

typedef EntityCompleter = Completer<List<SystemEntity>>;

class SystemEntitiesFetcher extends IEntitiesFetcher<Directory> {
  Directory currentDirectory;

  @override
  Directory get repository => currentDirectory;

  @override
  set repository(Directory directory) => repository = directory;

  EntityCompleter? _completer;

  SystemEntitiesFetcher(Directory initialDirectory)
      : currentDirectory = initialDirectory;

  @override
  Future<void> cancel() async {
    _completer?.complete(List<SystemEntity>.empty());
    _completer = null;
  }

  @override
  Future<List<SystemEntity>> fetch(Map<String, dynamic>? parameters) {
    _completer = EntityCompleter();
    final List<SystemEntity> entities = List.empty(growable: true);

    repository.list().listen(
      (entity) async {
        entities.add(
          SystemEntity(
            entity: entity,
            // Think about it (StatCacheProxy??)
            stats: SystemEntityStats.fromFileStat(
              await FileStat.stat(entity.path),
            ),
          ),
        );
      },
      onDone: () {
        if (_completer != null) {
          _completer?.complete(entities);
        }
      },
    );

    return _completer!.future;
  }
}
