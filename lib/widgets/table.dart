import 'package:entity/entity.dart';
import 'package:files/widgets/double_scrollbars.dart';
import 'package:files/widgets/entity_context_menu.dart';
import 'package:files/widgets/workspace.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

typedef EntityCallback = void Function(IEntity entity);
typedef DropAcceptCallback = void Function(String path);

typedef HeaderTapCallback = void Function(
  bool newAscending,
  int newColumnIndex,
);

typedef HeaderResizeCallback = void Function(
  int newColumnIndex,
  DragUpdateDetails details,
);

class FilesTable extends StatelessWidget {
  final List<IEntity> entities;
  final EntityCallback? onEntityTap;
  final EntityCallback? onEntityDoubleTap;
  final EntityCallback? onEntityLongTap;
  final EntityCallback? onEntitySecondaryTap;
  final DropAcceptCallback? onDropAccept;

  const FilesTable({
    required this.entities,
    this.onEntityTap,
    this.onEntityDoubleTap,
    this.onEntityLongTap,
    this.onEntitySecondaryTap,
    this.onDropAccept,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // NOTE: temporary solution
    final ScrollController verticalScrollController = ScrollController();
    final ScrollController horizontalScrollController = ScrollController();

    final WorkspaceController controller = WorkspaceController.of(context);

    return LayoutBuilder(
      builder: (context, constraints) => GestureDetector(
        onTap: () =>
            WorkspaceController.of(context, listen: false).clearSelectedItems(),
        child: DoubleScrollbars(
          horizontalController: horizontalScrollController,
          verticalController: verticalScrollController,
          child: ScrollProxy(
            direction: Axis.horizontal,
            child: SingleChildScrollView(
              controller: horizontalScrollController,
              scrollDirection: Axis.horizontal,
              child: ScrollProxy(
                direction: Axis.vertical,
                child: SizedBox(
                  height: constraints.maxHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            final IEntity entity = entities[index];

                            return Draggable<IEntity>(
                              data: entity,
                              dragAnchorStrategy: (_, __, ___) =>
                                  const Offset(32, 32),
                              feedback: Material(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.2),
                                child: Icon(
                                  entity.icon,
                                  color: entity.isDirectory
                                      ? Theme.of(context).colorScheme.secondary
                                      : Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withOpacity(0.8),
                                  size: 64,
                                ),
                              ),
                              child: Column(
                                children: [
                                  FilesTableRow(
                                    entity: entity,
                                    selected: controller.selectedItems
                                        .contains(entity),
                                    onTap: onEntityTap,
                                    onDoubleTap: onEntityDoubleTap,
                                    onLongTap: onEntityLongTap,
                                    onSecondaryTap: onEntitySecondaryTap,
                                    onDropAccept: onDropAccept,
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  )
                                ],
                              ),
                            );
                          },
                          padding: const EdgeInsets.only(top: 36),
                          itemCount: entities.length,
                          controller: verticalScrollController,
                        ),
                      ),
                      const FilesTableHeader(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FilesTableRow extends StatelessWidget {
  final IEntity entity;
  final bool selected;
  final EntityCallback? onTap;
  final EntityCallback? onDoubleTap;
  final EntityCallback? onLongTap;
  final EntityCallback? onSecondaryTap;
  final DropAcceptCallback? onDropAccept;

  const FilesTableRow({
    required this.entity,
    this.selected = false,
    this.onTap,
    this.onDoubleTap,
    this.onLongTap,
    this.onSecondaryTap,
    this.onDropAccept,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DragTarget<IEntity>(
      onWillAccept: (data) {
        if (!entity.isDirectory) return false;

        if (data!.path == entity.path) return false;

        return true;
      },
      onAccept: (_) => onDropAccept?.call(entity.path),
      builder: (context, _, __) => Material(
        color: selected
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.2)
            : Colors.transparent,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onTap?.call(entity),
          onDoubleTap: () {
            onTap?.call(entity);
            onDoubleTap?.call(entity);
          },
          onLongPress: () => onLongTap?.call(entity),
          child: EntityContextMenu(
            onOpen: () {
              onTap?.call(entity);
              onDoubleTap?.call(entity);
            },
            child: Row(
              children: SortType.values
                  .map(
                    (e) => TableRow(
                      entity: entity,
                      type: e,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class TableRow extends StatelessWidget {
  final IEntity entity;
  final SortType type;

  const TableRow({
    required this.entity,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    late final Widget child;

    switch (type) {
      case SortType.name:
        child = Row(
          children: [
            Icon(
              entity.icon,
              color: entity.isDirectory
                  ? Theme.of(context).colorScheme.secondary
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                Utils.getEntityName(entity.path),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        );
        break;
      case SortType.modified:
        child = Text(
          DateFormat("HH:mm - d MMM yyyy").format(entity.stats.modified),
          overflow: TextOverflow.ellipsis,
        );
        break;
      case SortType.extension:
        final String fileExtension =
            p.extension(entity.path).replaceAll(".", "").toUpperCase();
        final String fileLabel =
            fileExtension.isNotEmpty ? "File ($fileExtension)" : "File";
        child = Text(
          entity.isDirectory ? "Directory" : fileLabel,
          overflow: TextOverflow.ellipsis,
        );
        break;
      case SortType.size:
        child = Text(
          entity.isDirectory ? "" : filesize(entity.stats.size),
          overflow: TextOverflow.ellipsis,
        );
        break;
    }

    return Container(
      width: WorkspaceController.of(context).columnWidths[type.index],
      constraints: const BoxConstraints(minWidth: 80),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    );
  }
}

class FilesTableHeader extends StatelessWidget {
  const FilesTableHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: Material(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...SortType.values.map((e) => HeaderCell(e)),
            Container(
              width: 8.0,
              color: Theme.of(context).colorScheme.background,
            ),
          ],
        ),
      ),
    );
  }
}

class HeaderCell extends StatelessWidget {
  final SortType type;

  const HeaderCell(this.type);

  @override
  Widget build(BuildContext context) {
    late String columnTitle;

    switch (type) {
      case SortType.name:
        columnTitle = "Name";
        break;
      case SortType.modified:
        columnTitle = "Date";
        break;
      case SortType.extension:
        columnTitle = "Type";
        break;
      case SortType.size:
        columnTitle = "Size";
        break;
    }

    final Widget child = SizedBox.expand(
      child: Row(
        children: [
          Expanded(
            child: Text(
              columnTitle,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (WorkspaceController.of(context).sortType == type)
            Icon(
              WorkspaceController.of(context).ascending
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
              size: 16,
            ),
        ],
      ),
    );

    return InkWell(
      onTap: () {
        final WorkspaceController workspace =
            WorkspaceController.of(context, listen: false);

        if (workspace.sortType == type) {
          workspace.ascending = !workspace.ascending;
        } else {
          workspace.ascending = true;
          workspace.sortType = type;
        }
        workspace.reload();
      },
      child: Container(
        width: WorkspaceController.of(context).columnWidths[type.index],
        constraints: const BoxConstraints(minWidth: 80),
        padding: const EdgeInsetsDirectional.only(start: 16.0),
        child: Stack(
          clipBehavior: Clip.none,
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 8,
                  end: 8,
                ),
                child: child,
              ),
            ),
            PositionedDirectional(
              end: -3,
              top: 0,
              bottom: 0,
              width: 8,
              child: MouseRegion(
                cursor: SystemMouseCursors.resizeColumn,
                opaque: false,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onHorizontalDragUpdate: (details) {
                    WorkspaceController.of(context, listen: false)
                        .addToColumnWidth(type.index, details.primaryDelta!);
                  },
                  child: const VerticalDivider(width: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
