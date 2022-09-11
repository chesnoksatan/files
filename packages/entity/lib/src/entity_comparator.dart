import 'package:entity/entity.dart';

enum SortType {
  name,
  modified,
  extension,
  size,
}

/// Helper class for sorting [IEntity]
///
/// Specifies the sort criteria and sort order
class EntityComparator {
  EntityComparator({
    this.ascending = true,
    this.sortType = SortType.name,
  });

  bool ascending;
  SortType sortType;

  int compare(IEntity a, IEntity b) {
    final IEntity first = ascending ? a : b;
    final IEntity second = ascending ? b : a;

    switch (sortType) {
      case SortType.modified:
        return first.stats.modified.compareTo(second.stats.modified);
      case SortType.extension:
        return first.mimeType
            .toLowerCase()
            .compareTo(second.mimeType.toLowerCase());
      // NOTE: probably not good idea
      case SortType.size:
        return first.stats.size.compareTo(second.stats.size);
      case SortType.name:
      default:
        return first.name.toLowerCase().compareTo(second.name.toLowerCase());
    }
  }
}
