import 'package:flutter/material.dart';

class ToroAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ToroAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Where is my toro?'),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
