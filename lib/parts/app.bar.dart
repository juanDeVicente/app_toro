import 'package:flutter/material.dart';

import 'distance.dialog.dart';

class ToroAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  const ToroAppBar({Key? key, this.actions}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Where is my toro?'),
      actions: actions ??
          [
            IconButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => const DistanceDialog()),
                icon: const Icon(Icons.settings))
          ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
