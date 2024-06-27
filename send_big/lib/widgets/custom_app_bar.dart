import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback toggleMenu;

  const CustomAppBar({
    super.key,
    required this.toggleMenu,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      titleSpacing: 4,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            // 'assets/images/sendBig.png',
            'assets/images/logo.PNG',
            // height: 160,
            // width: 160,
          ),
          IconButton(
            onPressed: toggleMenu,
            icon: const Icon(Icons.menu),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
