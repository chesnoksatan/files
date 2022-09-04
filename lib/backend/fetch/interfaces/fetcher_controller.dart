import 'package:files/backend/fetch/interfaces/entities_fetcher.dart';
import 'package:files/backend/fetch/interfaces/entity.dart';
import 'package:flutter/material.dart';

abstract class IFetcherController with ChangeNotifier {
  IEntitiesFetcher fetcher;
  final List<IEntity> entities = List.empty(growable: true);
  // String currentPath;
  // SortType sortType;
  // bool ascending;

  IFetcherController(this.fetcher) {
    fetcher.addListener(notifyListeners);
  }

  bool get inProgress => fetcher.inProgress;

  Future<void> fetch() async {
    if (fetcher.inProgress) fetcher.cancel();

    entities.clear();
    entities.addAll(await fetcher.fetch());
    notifyListeners();
  }

  List<IEntity> getEntities();

  // TODO: other methods
}
