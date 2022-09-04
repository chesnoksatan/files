import 'dart:async';
import 'dart:io';

import 'package:files/backend/fetch/interfaces/entities_fetcher.dart';
import 'package:files/backend/fetch/system/system_entity.dart';

typedef EntityCompleter = Completer<List<SystemEntity>>;

class SystemEntitiesFetcher extends IEntitiesFetcher {
  Directory directory;

  EntityCompleter? completer;

  SystemEntitiesFetcher(this.directory);

  @override
  void cancel() {
    if (!inProgress) return;

    inProgress = false;
    completer?.complete(List<SystemEntity>.empty());
  }

  @override
  Future<List<SystemEntity>> fetch() async {
    completer = Completer();
    inProgress = true;

    final List<SystemEntity> entities = List.empty(growable: true);

    directory.list().listen(
      (entity) => entities.add(SystemEntity(entity)),
      onDone: () {
        inProgress = false;
        completer!.complete(entities);
      },
    );

    return completer!.future;
  }
}
