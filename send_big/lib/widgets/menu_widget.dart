import 'dart:developer';
import 'package:flutter/material.dart';

import '../screens/auth/login.dart';
import '../widgets/language_dropdown.dart';
import '../constants/languages.dart';
import '../models/languages.dart';
import '../constants/menus.dart';

class MenuWidget extends StatefulWidget {
  final bool isMenuOpen;
  final VoidCallback toggleMenu;

  const MenuWidget({
    super.key,
    required this.isMenuOpen,
    required this.toggleMenu,
  });

  @override
  // ignore: library_private_types_in_public_api
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  bool isDropdownOpened = false;
  Language? selectedLanguage;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    selectedLanguage = languages[0];
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _opacityAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.isMenuOpen) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(MenuWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isMenuOpen != oldWidget.isMenuOpen) {
      if (widget.isMenuOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  void _showLoginOverlay(BuildContext ctx) {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(ctx).insert(_overlayEntry!);
  }

  void _removeLoginOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (ctx) => LoginOverlay(
        onClose: _removeLoginOverlay,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const LanguageDropdown(),
                ..._buildListItems(),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4)),
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 16,
                      // fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < menuItems.length; ++i) {
      listItems.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () => _handleMenuItemTap(context, menuItems[i].label!),
                child: Text(
                  menuItems[i].label!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (menuItems[i].showNewTag)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: const Color.fromARGB(255, 36, 153, 248),
                  ),
                  height: 25,
                  child: const Text(
                    'New',
                    style: TextStyle(color: Colors.white),
                  ),
                )
            ],
          ),
        ),
      );
    }
    return listItems;
  }

  void _handleMenuItemTap(BuildContext context, String label) {
    switch (label) {
      case 'Snap':
        log('Snap tapped');
        break;
      case 'Max':
        log('Max tapped');
        break;
      case 'Help':
        log('Help tapped');
        break;
      case 'Blog':
        log('Blog tapped');
        break;
      case 'Login':
        _showLoginOverlay(context);
        break;
    }
  }
}
