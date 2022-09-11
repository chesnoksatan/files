import 'package:animations/animations.dart';
import 'package:entity/entity.dart';
import 'package:files/backend/providers.dart';
import 'package:files/widgets/side_pane.dart';
import 'package:files/widgets/tab_strip.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilesHome extends StatefulWidget {
  const FilesHome({Key? key}) : super(key: key);

  @override
  _FilesHomeState createState() => _FilesHomeState();
}

class _FilesHomeState extends State<FilesHome> {
  final List<SideDestination> sideDestinations = [];
  final List<WorkspaceController> workspaces = [];
  final PageStorageBucket bucket = PageStorageBucket();
  int currentWorkspace = 0;

  String get currentDir => workspaces[currentWorkspace].currentDir;

  @override
  void initState() {
    super.initState();
    for (final MapEntry<String, IconData> element
        in folderProvider.directories) {
      sideDestinations.add(
        SideDestination(
          element.value,
          Utils.getEntityName(element.key),
          element.key,
        ),
      );
    }
    workspaces
        .add(WorkspaceController(initialDir: sideDestinations.first.path));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ChangeNotifierProvider<WorkspaceController>.value(
          value: workspaces[currentWorkspace],
          builder: (context, child) => SidePane(
            destinations: sideDestinations,
            onNewTab: (String tabPath) {
              workspaces.add(WorkspaceController(initialDir: tabPath));
              currentWorkspace = workspaces.length - 1;
              setState(() {});
            },
          ),
        ),
        Expanded(
          child: Material(
            color: Theme.of(context).colorScheme.background,
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: TabStrip(
                    tabs: workspaces,
                    selectedTab: currentWorkspace,
                    allowClosing: workspaces.length > 1,
                    onTabChanged: (index) =>
                        setState(() => currentWorkspace = index),
                    onTabClosed: (index) {
                      workspaces.removeAt(index);
                      if (index < workspaces.length) {
                        currentWorkspace = index;
                      } else if (index - 1 >= 0) {
                        currentWorkspace = index - 1;
                      }
                      setState(() {});
                    },
                    onNewTab: () {
                      workspaces
                          .add(WorkspaceController(initialDir: currentDir));
                      currentWorkspace = workspaces.length - 1;
                      setState(() {});
                    },
                  ),
                ),
                Expanded(
                  child: PageTransitionSwitcher(
                    transitionBuilder:
                        (child, primaryAnimation, secondaryAnimation) {
                      return SharedAxisTransition(
                        animation: primaryAnimation,
                        secondaryAnimation: secondaryAnimation,
                        transitionType: SharedAxisTransitionType.scaled,
                        fillColor: Colors.transparent,
                        child: child,
                      );
                    },
                    child: FilesWorkspace(
                      key: ValueKey(currentWorkspace),
                      controller: workspaces[currentWorkspace],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
