import 'package:entity/entity.dart';
import 'package:fetcher_api/src/entities_fetcher.dart';
import 'package:flutter/material.dart';

abstract class IEntitiesFetcherController with ChangeNotifier {
  IEntitiesFetcher fetcher;
  final EntityComparator comparator = EntityComparator();

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

  bool get ascending => comparator.ascending;
  set ascending(bool flag) {
    if (comparator.ascending != flag) {
      comparator.ascending = flag;
      sortEntities();
    }
  }

  SortType get sortType => comparator.sortType;
  set sortType(SortType type) {
    if (comparator.sortType != type) {
      comparator.sortType = type;
      sortEntities();
    }
  }

  void reload();

  // Future<void> fetch<T>(T path) async {
  //   if (inProgress) {
  //     fetcher.cancel();
  //     inProgress = false;
  //   }

  //   inProgress = true;
  //   entities.clear();
  //   entities
  //     ..addAll(await fetcher.fetch(path))
  //     ..removeWhere((entity) => !showHidden && entity.name.startsWith("."));
  //   sortEntities();
  //   inProgress = false;
  // }

  void sortEntities() {
    late final List<IEntity> result;

    if (_directoriesFirst) {
      final List<IEntity> directories =
          entities.where((element) => element.isDirectory).toList();

      final List<IEntity> files =
          entities.where((element) => !element.isDirectory).toList();

      directories.sort(((a, b) => comparator.compare(a, b)));
      files.sort(((a, b) => comparator.compare(a, b)));

      result = [...directories, ...files];
    } else {
      result = List.from(entities)..sort((a, b) => comparator.compare(a, b));
    }

    entities
      ..clear()
      ..addAll(result);
    notifyListeners();
  }
}
