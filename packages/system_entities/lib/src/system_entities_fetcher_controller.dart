import 'dart:io';

import 'package:fetcher_api/fetcher_api.dart';
import 'package:system_entities/src/system_entities_fetcher.dart';

class SystemEntitiesFetcherController extends IEntitiesFetcherController {
  final Map<String, dynamic> parameters = <String, dynamic>{};

  SystemEntitiesFetcherController(Directory initialDirectory)
      : super(SystemEntitiesFetcher(initialDirectory)) {
    fetch(parameters);
  }

  void changeDirectory(Directory directory) {
    (fetcher as SystemEntitiesFetcher).currentDirectory = directory;
    fetch(parameters);
  }

  @override
  void reload() => fetch(parameters);

  Directory get currentDir =>
      (fetcher as SystemEntitiesFetcher).currentDirectory;
}
