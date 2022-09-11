import 'dart:async';
import 'dart:io';

import 'package:entity/entity.dart';
import 'package:files/backend/entity_info.dart';
// import 'package:files/backend/fetch.dart';
import 'package:files/backend/path_parts.dart';
// import 'package:files/backend/utils.dart';
import 'package:files/widgets/breadcrumbs_bar.dart';
import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:files/widgets/grid.dart';
// import 'package:files/widgets/table.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:system_entities/system_entities.dart';
import 'package:url_launcher/url_launcher.dart';

class FilesWorkspace extends StatefulWidget {
  final WorkspaceController controller;

  const FilesWorkspace({
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  _FilesWorkspaceState createState() => _FilesWorkspaceState();
}

class _FilesWorkspaceState extends State<FilesWorkspace> {
  /* TO KEEP */
  late final CachingScrollController horizontalController;
  late final CachingScrollController verticalController;
  late TextEditingController textController;

  WorkspaceController get controller => widget.controller;

  String folderName = ' ';

  IconData get viewIcon {
    switch (controller.view) {
      case WorkspaceView.grid:
        return Icons.grid_view_outlined;
      case WorkspaceView.table:
      default:
        return Icons.list_outlined;
    }
  }

  @override
  void initState() {
    super.initState();
    horizontalController = CachingScrollController(
      initialScrollOffset: controller.lastHorizontalScrollOffset,
    );
    verticalController = CachingScrollController(
      initialScrollOffset: controller.lastVerticalScrollOffset,
    );
    textController = TextEditingController();
    controller.addListener(onControllerUpdate);
  }

  @override
  void dispose() {
    controller.lastHorizontalScrollOffset =
        horizontalController.lastPosition.pixels;
    controller.lastVerticalScrollOffset =
        verticalController.lastPosition.pixels;
    textController.dispose();
    controller.removeListener(onControllerUpdate);
    super.dispose();
  }

  void _setSortType(SortType? type) {
    if (type != null) controller.sortType = type;
  }

  Future<void> _createFolder() async {
    final folderNameDialog = await openDialog();
    final PathParts currentDir = PathParts.parse(controller.currentDir);
    currentDir.parts.add('$folderNameDialog');
    if (folderNameDialog != null) {
      await Directory(currentDir.toPath()).create(recursive: true);
      controller.currentDir = currentDir.toPath();
    }
  }

  void _switchWorkspaceView() {
    setState(() {
      switch (controller.view) {
        case WorkspaceView.table:
          controller.view = WorkspaceView.grid;
          break;
        case WorkspaceView.grid:
          controller.view = WorkspaceView.table;
          break;
      }
    });
  }

  void onControllerUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 48,
          child: BreadcrumbsBar(
            path: PathParts.parse(controller.currentDir),
            onBreadcrumbPress: (value) {
              controller.currentDir =
                  PathParts.parse(controller.currentDir).toPath(value);
            },
            onPathSubmitted: (path) async {
              final bool exists = await Directory(path).exists();

              if (exists) {
                controller.currentDir = path;
              } else {
                setState(() {});
              }
            },
            leading: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_upward,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    PathParts backDir = PathParts.parse(controller.currentDir);
                    controller.currentDir =
                        backDir.toPath(backDir.parts.length - 1);
                  });
                },
                splashRadius: 16,
              ),
            ],
            actions: [
              IconButton(
                icon: Icon(
                  viewIcon,
                  size: 20,
                  color: Colors.white,
                ),
                onPressed: _switchWorkspaceView,
                splashRadius: 16,
              ),
              PopupMenuButton<String>(
                splashRadius: 16,
                color: Theme.of(context).colorScheme.surface,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4)),
                ),
                offset: const Offset(0, 50),
                itemBuilder: (context) => [
                  ContextMenuEntry(
                    id: 'showHidden',
                    shortcut: Switch(
                      value: controller.showHidden,
                      onChanged: (flag) {
                        controller.showHidden = flag;
                        Navigator.pop(context);
                      },
                    ),
                    title: const Text('Show hidden files'),
                    onTap: () => controller.showHidden = !controller.showHidden,
                  ),
                  ContextMenuEntry(
                    id: 'directoriesFirst',
                    title: const Text('Sort folders before files'),
                    shortcut: Switch(
                      value: controller.directoriesFirst,
                      onChanged: (flag) {
                        controller.directoriesFirst = flag;
                        Navigator.pop(context);
                      },
                    ),
                    onTap: () => controller.directoriesFirst =
                        !controller.directoriesFirst,
                  ),
                  ContextMenuEntry(
                    id: 'createFolder',
                    title: const Text('Create new folder'),
                    onTap: () => _createFolder(),
                  ),
                  const ContextMenuDivider(),
                  ContextMenuEntry(
                    id: 'name',
                    title: const Text('Name'),
                    onTap: () => _setSortType(SortType.name),
                    shortcut: Radio<SortType>(
                      value: SortType.name,
                      groupValue: controller.sortType,
                      onChanged: (SortType? type) {
                        _setSortType(type);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ContextMenuEntry(
                    id: 'modifies',
                    title: const Text('Modifies'),
                    onTap: () => _setSortType(SortType.modified),
                    shortcut: Radio<SortType>(
                      value: SortType.modified,
                      groupValue: controller.sortType,
                      onChanged: (SortType? type) {
                        _setSortType(type);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ContextMenuEntry(
                    id: 'size',
                    title: const Text('Size'),
                    onTap: () => _setSortType(SortType.size),
                    shortcut: Radio<SortType>(
                      value: SortType.size,
                      groupValue: controller.sortType,
                      onChanged: (SortType? type) {
                        _setSortType(type);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  ContextMenuEntry(
                    id: 'extension',
                    title: const Text('Type'),
                    onTap: () => _setSortType(SortType.extension),
                    shortcut: Radio<SortType>(
                      value: SortType.extension,
                      groupValue: controller.sortType,
                      onChanged: (SortType? type) {
                        _setSortType(type);
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const ContextMenuDivider(),
                  ContextMenuEntry(
                    id: 'ascending',
                    title: const Text('Ascending'),
                    onTap: () => controller.ascending = true,
                    leading:
                        controller.ascending ? const Icon(Icons.check) : null,
                  ),
                  ContextMenuEntry(
                    id: 'descending',
                    title: const Text('Descending'),
                    onTap: () => controller.ascending = false,
                    leading:
                        controller.ascending ? null : const Icon(Icons.check),
                  ),
                  const ContextMenuDivider(),
                  ContextMenuEntry(
                    id: 'reload',
                    title: const Text('Reload'),
                    onTap: controller.reload,
                  ),
                ],
              ),
            ],
            // loadingProgress: controller.loadingProgress,
          ),
        ),
        Expanded(
          child: ChangeNotifierProvider.value(
            value: controller,
            child: body,
          ),
        ),
        SizedBox(
          height: 32,
          child: Material(
            color: Theme.of(context).colorScheme.background,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text("${controller.currentEntities.length} items"),
                  const Spacer(),
                  Text(selectedItemsLabel),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<String?> openDialog() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("New Folder"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "Folder name",
            ),
            controller: textController,
            onSubmitted: (value) {
              Navigator.pop(context, value);
            },
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text("Create"),
              onPressed: textController.text != ""
                  ? () => showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                            title: const Text("Folder name cannot be empty"),
                            actions: [
                              TextButton(
                                child: Text("OK"),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ]),
                      )
                  : () => Navigator.of(context).pop(textController.text),
            ),
          ],
        ),
      );

  String get selectedItemsLabel {
    if (controller.selectedItems.isEmpty) return "";

    late String itemLabel;

    if (controller.selectedItems.length == 1) {
      itemLabel = "item";
    } else {
      itemLabel = "items";
    }

    String baseString =
        "${controller.selectedItems.length} selected $itemLabel";

    if (controller.selectedItems.every((element) => element.isFile)) {
      int totalSize = controller.selectedItems.fold(
          0, (previousValue, element) => previousValue + element.stats.size);
      baseString += " ${filesize(totalSize)}";
    }

    return baseString;
  }

  void _onEntityTap(IEntity entity) {
    final bool selected = controller.selectedItems.contains(entity);
    final Set<LogicalKeyboardKey> keysPressed =
        RawKeyboard.instance.keysPressed;
    final bool multiSelect = keysPressed.contains(
          LogicalKeyboardKey.controlLeft,
        ) ||
        keysPressed.contains(
          LogicalKeyboardKey.controlRight,
        );

    if (!multiSelect) controller.clearSelectedItems();

    if (!selected && multiSelect) {
      controller.addSelectedItem(entity);
    } else if (selected && multiSelect) {
      controller.removeSelectedItem(entity);
    } else {
      controller.addSelectedItem(entity);
    }
    setState(() {});
  }

  void _onEntityDoubleTap(IEntity entity) {
    if (entity.isDirectory) {
      controller.currentDir = entity.path;
    } else {
      launch(entity.path);
    }
  }

  // For move more than one file
  // TODO:
  void _onDropAccepted(String path) {
    // for (final entity in controller.selectedItems) {
    //   Utils.moveFileToDest(entity.entity, path);
    // }
  }

  Widget get body {
    return Builder(
      builder: (context) {
        if (!controller.inProgress) {
          if (controller.currentEntities.isNotEmpty) {
            return FilesGrid(
              entities: controller.currentEntities,
              onEntityTap: _onEntityTap,
              onEntityDoubleTap: _onEntityDoubleTap,
              // onDropAccept: _onDropAccepted,
            );
            // switch (controller.view) {
            //   case WorkspaceView.grid:
            //     return FilesGrid(
            //       entities: controller.currentInfo!,
            //       onEntityTap: _onEntityTap,
            //       onEntityDoubleTap: _onEntityDoubleTap,
            //       onDropAccept: _onDropAccepted,
            //     );
            //   default:
            //     return FilesTable(
            //       rows: controller.currentInfo!
            //           .map(
            //             (entity) => FilesRow(
            //               entity: entity,
            //               selected: controller.selectedItems.contains(entity),
            //               onTap: () => _onEntityTap(entity),
            //               onDoubleTap: () => _onEntityDoubleTap(entity),
            //             ),
            //           )
            //           .toList(),
            //       columns: [
            //         FilesColumn(
            //           width: controller.columnWidths[0],
            //           type: FilesColumnType.name,
            //         ),
            //         FilesColumn(
            //           width: controller.columnWidths[1],
            //           type: FilesColumnType.date,
            //         ),
            //         FilesColumn(
            //           width: controller.columnWidths[2],
            //           type: FilesColumnType.type,
            //           allowSorting: false,
            //         ),
            //         FilesColumn(
            //           width: controller.columnWidths[3],
            //           type: FilesColumnType.size,
            //         ),
            //       ],
            //       ascending: controller.ascending,
            //       columnIndex: controller.columnIndex,
            //       onHeaderCellTap: (newAscending, newColumnIndex) {
            //         if (controller.columnIndex == newColumnIndex) {
            //           controller.ascending = newAscending;
            //         } else {
            //           controller.ascending = true;
            //           controller.columnIndex = newColumnIndex;
            //         }
            //         controller.changeCurrentDir(controller.currentDir);
            //       },
            //       onHeaderResize: (newColumnIndex, details) {
            //         controller.addToColumnWidth(
            //           newColumnIndex,
            //           details.primaryDelta!,
            //         );
            //       },
            //       horizontalController: horizontalController,
            //       verticalController: verticalController,
            //     );
            // }
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.folder_open_outlined,
                    size: 80,
                  ),
                  Text(
                    "This Folder is Empty",
                    style: TextStyle(fontSize: 17),
                  )
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

enum WorkspaceView { table, grid }

class WorkspaceController with ChangeNotifier {
  WorkspaceController({required String initialDir}) {
    systemFetcherController =
        SystemEntitiesFetcherController(Directory(initialDir));
    systemFetcherController.addListener(notifyListeners);
  }

  double lastHorizontalScrollOffset = 0.0;
  double lastVerticalScrollOffset = 0.0;
  final List<double> _columnWidths = [480, 180, 120, 120];
  int _columnIndex = 0;
  final List<IEntity> _selectedItems = [];
  double? _loadingProgress;
  StreamSubscription<FileSystemEvent>? directoryStream;
  WorkspaceView _view = WorkspaceView.table; // save on SharedPreferences?

  late SystemEntitiesFetcherController systemFetcherController;

  List<IEntity> get currentEntities => systemFetcherController.entities;
  bool get inProgress => systemFetcherController.inProgress;

  String get currentDir => systemFetcherController.currentDir.path;
  set currentDir(String value) {
    changeCurrentDir(value);
  }

  void reload() => systemFetcherController.reload();

  bool get ascending => systemFetcherController.ascending;
  set ascending(bool value) => systemFetcherController.ascending = value;

  bool get showHidden => systemFetcherController.showHidden;
  set showHidden(bool value) => systemFetcherController.showHidden = value;

  bool get directoriesFirst => systemFetcherController.directoriesFirst;
  set directoriesFirst(bool value) =>
      systemFetcherController.directoriesFirst = value;

  int get columnIndex => _columnIndex;
  set columnIndex(int value) {
    _columnIndex = value;
    notifyListeners();
  }

  SortType get sortType => systemFetcherController.sortType;
  set sortType(SortType value) => systemFetcherController.sortType = value;

  WorkspaceView get view => _view;
  set view(WorkspaceView value) {
    _view = value;
    notifyListeners();
  }

  List<double> get columnWidths => List.unmodifiable(_columnWidths);
  void setColumnWidth(int index, double width) {
    _columnWidths[index] = width;
    notifyListeners();
  }

  void addToColumnWidth(int index, double delta) {
    _columnWidths[index] += delta;
    notifyListeners();
  }

  List<IEntity> get selectedItems => List.unmodifiable(_selectedItems);
  void addSelectedItem(IEntity info) {
    _selectedItems.add(info);
    notifyListeners();
  }

  void removeSelectedItem(IEntity info) {
    _selectedItems.remove(info);
    notifyListeners();
  }

  void clearSelectedItems() {
    _selectedItems.clear();
    notifyListeners();
  }

  Future<void> changeCurrentDir(String newDir) async {
    // clearCurrentInfo();
    clearSelectedItems();
    await directoryStream?.cancel();
    // await getInfoForDir(Directory(newDir));
    directoryStream =
        Directory(newDir).watch().listen(_directoryStreamListener);
    systemFetcherController.changeDirectory(Directory(newDir));
  }

  void _directoryStreamListener(FileSystemEvent event) {
    systemFetcherController.reload();
  }

  static WorkspaceController of(BuildContext context, {bool listen = true}) {
    return Provider.of<WorkspaceController>(context, listen: listen);
  }
}

class CachingScrollController extends ScrollController {
  CachingScrollController({
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
    String? debugLabel,
  }) : super(
          initialScrollOffset: initialScrollOffset,
          keepScrollOffset: keepScrollOffset,
          debugLabel: debugLabel,
        );

  bool _inited = false;
  late ScrollPosition lastPosition;

  @override
  void attach(ScrollPosition position) {
    lastPosition = position;
    super.attach(position);
  }

  @override
  ScrollPosition createScrollPosition(
    ScrollPhysics physics,
    ScrollContext context,
    ScrollPosition? oldPosition,
  ) {
    late final double initialPixels;

    if (!_inited) {
      initialPixels = initialScrollOffset;
      _inited = true;
    } else {
      initialPixels = 0;
    }

    return ScrollPositionWithSingleContext(
      physics: physics,
      context: context,
      initialPixels: initialPixels,
      keepScrollOffset: keepScrollOffset,
      oldPosition: oldPosition,
      debugLabel: debugLabel,
    );
  }
}
