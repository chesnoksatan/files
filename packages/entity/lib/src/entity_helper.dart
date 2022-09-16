import 'package:entity/entity.dart';

enum Operation { copy, cut }

/// Base class for handling basic actions on a IEntity
abstract class IEntityHelper {
  final List<IEntity> clipboard = List<IEntity>.empty(growable: true);
  Operation? currentOperation;

  void copy(IEntity entity) {
    currentOperation = Operation.copy;
    clipboard.clear();
    clipboard.add(entity);
  }

  void copyAll(List<IEntity> entities) {
    currentOperation = Operation.copy;
    clipboard.clear();
    clipboard.addAll(entities);
  }

  void cut(IEntity entity) {
    currentOperation = Operation.cut;
    clipboard.clear();
    clipboard.add(entity);
  }

  void cutAll(List<IEntity> entities) {
    currentOperation = Operation.cut;
    clipboard.clear();
    clipboard.addAll(entities);
  }

  void pasteSync(String dest);
  Future<void> paste(String dest);

  void deleteSync(IEntity entity);
  Future<void> delete(IEntity entity);

  void deleteAllSync(List<IEntity> entities);
  Future<void> deleteAll(List<IEntity> entities);

  void renameSync(IEntity entity, String newName);
  Future<void> rename(IEntity entity, String newName);

  void renameAllSync(List<IEntity> entities, String newName);
  Future<void> renameAll(List<IEntity> entities, String newName);
}
