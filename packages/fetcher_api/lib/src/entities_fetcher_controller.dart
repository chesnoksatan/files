import 'package:entity/entity.dart';
import 'package:fetcher_api/src/entities_fetcher.dart';
import 'package:flutter/material.dart';

abstract class IEntitiesFetcherController with ChangeNotifier {
  IEntitiesFetcher fetcher;
  final EntityComparator _comparator = EntityComparator();

  final List<IEntity> entities = List.empty(growable: true);

  IEntitiesFetcherController(this.fetcher);

  Future<void> fetch(Map<String, dynamic>? parameters) async {
    await cancel();

    inProgress = true;
    entities.clear();
    entities
      ..addAll(await fetcher.fetch(parameters))
      ..removeWhere((entity) => !showHidden && entity.name.startsWith("."));
    sortEntities();
    inProgress = false;
  }

  Future<void> cancel() async {
    if (inProgress) {
      await fetcher.cancel();
      inProgress = false;
    }
  }

  bool _inProgress = false;
  bool _showHidden = false;
  bool _directoriesFirst = true;

  bool get inProgress => _inProgress;
  set inProgress(bool flag) {
    _inProgress = flag;
    notifyListeners();
  }

  bool get showHidden => _showHidden;
  set showHidden(bool flag) {
    if (_showHidden != flag) {
      _showHidden = flag;
      reload();
    }
  }

  bool get directoriesFirst => _directoriesFirst;
  set directoriesFirst(bool flag) {
    if (_directoriesFirst != flag) {
      _directoriesFirst = flag;
      sortEntities();
    }
  }

  bool get ascending => _comparator.ascending;
  set ascending(bool flag) {
    if (_comparator.ascending != flag) {
      _comparator.ascending = flag;
      sortEntities();
    }
  }

  SortType get sortType => _comparator.sortType;
  set sortType(SortType type) {
    if (_comparator.sortType != type) {
      _comparator.sortType = type;
      sortEntities();
    }
  }

  void reload();

  void sortEntities() {
    late final List<IEntity> result;

    if (_directoriesFirst) {
      final List<IEntity> directories =
          entities.where((element) => element.isDirectory).toList();

      final List<IEntity> files =
          entities.where((element) => !element.isDirectory).toList();

      directories.sort(((a, b) => _comparator.compare(a, b)));
      files.sort(((a, b) => _comparator.compare(a, b)));

      result = [...directories, ...files];
    } else {
      result = List.from(entities)..sort((a, b) => _comparator.compare(a, b));
    }

    entities
      ..clear()
      ..addAll(result);
    notifyListeners();
  }

  IEntity? getEntityByPath(String path) {
    for (final IEntity entity in entities) {
      if (entity.path == path) return entity;
    }
    return null;
  }

  IEntity? getEntityByName(String name) {
    for (final IEntity entity in entities) {
      if (entity.name == name) return entity;
    }
    return null;
  }
}
