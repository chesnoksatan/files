import 'package:files/widgets/context_menu/context_menu.dart';
import 'package:files/widgets/context_menu/context_menu_entry.dart';
import 'package:files/widgets/workspace.dart';
import 'package:flutter/material.dart';

typedef NewTabCallback = void Function(String);

class SidePane extends StatelessWidget {
  final List<SideDestination> destinations;
  final NewTabCallback onNewTab;

  const SidePane({
    required this.destinations,
    required this.onNewTab,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 304,
      child: Material(
        color: Theme.of(context).colorScheme.surface,
        child: ListView.builder(
          padding: const EdgeInsets.only(top: 56),
          itemCount: destinations.length,
          itemBuilder: (context, index) => ContextMenu(
            entries: [
              ContextMenuEntry(
                id: 'open',
                title: const Text("Open"),
                onTap: () => WorkspaceController.of(context, listen: false)
                    .currentDir = destinations[index].path,
              ),
              ContextMenuEntry(
                id: 'open_in_new_tab',
                title: const Text("Open in new tab"),
                onTap: () => onNewTab(destinations[index].path),
              ),
              ContextMenuEntry(
                id: 'open_in_new_window',
                title: const Text("Open in new window"),
                onTap: () {},
                enabled: false,
              ),
            ],
            child: ListTile(
              dense: true,
              leading: Icon(destinations[index].icon),
              selected: WorkspaceController.of(context).currentDir ==
                  destinations[index].path,
              selectedTileColor:
                  Theme.of(context).colorScheme.secondary.withOpacity(0.1),
              title: Text(destinations[index].label),
              onTap: () => WorkspaceController.of(context, listen: false)
                  .currentDir = destinations[index].path,
            ),
          ),
        ),
      ),
    );
  }
}

class SideDestination {
  final IconData icon;
  final String label;
  final String path;

  const SideDestination(this.icon, this.label, this.path);
}
