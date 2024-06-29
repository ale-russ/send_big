import 'package:flutter/material.dart';

import '../widgets/home_elements.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/menu_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isMenuOpen = false;

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        toggleMenu: _toggleMenu,
      ),
      body: Stack(
        children: [
          const HomeElements(),
          if (isMenuOpen)
            MenuWidget(
              isMenuOpen: isMenuOpen,
              toggleMenu: _toggleMenu,
            ),
        ],
      ),
    );
  }
}
