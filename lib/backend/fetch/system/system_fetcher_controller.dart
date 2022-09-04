import 'dart:io';

import 'package:files/backend/fetch/interfaces/entity.dart';
import 'package:files/backend/fetch/interfaces/fetcher_controller.dart';
import 'package:files/backend/fetch/system/system_entities_fetcher.dart';

class SystemFetcherController extends IFetcherController {
  SystemFetcherController(Directory directory)
      : super(SystemEntitiesFetcher(directory));

  @override
  List<IEntity> getEntities() => entities;

  void changeDirectory(Directory directory) {
    (fetcher as SystemEntitiesFetcher).directory = directory;
    fetch().then(
      (_) => entities.sort(
        (a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()),
      ),
    );
  }
}
