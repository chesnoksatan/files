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

  IEntity createSync(String path, EntityType type);
  Future<IEntity> create(String path, EntityType type);
}
