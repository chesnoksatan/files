import 'package:entity/entity.dart';

/// Base class for fetching path content
abstract class IEntitiesFetcher<T> {
  Future<void> cancel();
  Future<List<IEntity>> fetch(Map<String, dynamic>? parameters);

  T get repository;
  set repository(T newRepository);
}
