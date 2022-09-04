import 'package:files/backend/fetch/interfaces/entity.dart';
import 'package:flutter/material.dart';

abstract class IEntitiesFetcher with ChangeNotifier {
  bool _inProgress = false;

  Future<List<IEntity>> fetch();

  void cancel();

  bool get inProgress => _inProgress;
  set inProgress(bool flag) {
    _inProgress = flag;
    notifyListeners();
  }
}
