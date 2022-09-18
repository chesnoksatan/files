import 'dart:io';

import 'package:fetcher_api/fetcher_api.dart';
import 'package:system_entities/src/system_entities_fetcher.dart';

class SystemEntitiesFetcherController extends IEntitiesFetcherController {
  final Map<String, dynamic> parameters;

  SystemEntitiesFetcherController(Directory initialDirectory,
      {Map<String, dynamic>? parameters})
      : parameters = parameters ?? <String, dynamic>{},
        super(SystemEntitiesFetcher(initialDirectory)) {
    changeDirectory(initialDirectory);
  }

  void changeDirectory(Directory directory) {
    (fetcher as SystemEntitiesFetcher).currentDirectory = directory;
    directory.watch().listen(directoryListener);
    fetch(parameters);
  }

  @override
  void reload() => fetch(parameters);

  Directory get currentDir =>
      (fetcher as SystemEntitiesFetcher).currentDirectory;

  void directoryListener(FileSystemEvent event) {
    if (event is FileSystemDeleteEvent || event is FileSystemMoveEvent) {
      entities.removeWhere((entity) => entity.path == event.path);
      sortEntities();
    } else {
      // TODO: Add support for FileSystemMoveEvent && FileSystemDeleteEvent
      reload();
    }
  }
}
