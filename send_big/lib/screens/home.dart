import 'package:flutter/material.dart';
import '../models/languages.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/menu_widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isMenuOpen = false;
  Language? selectedLanguage;

  final List<Language> languages = [
    Language('ENGLISH', 'EN'),
    Language('FRANCE | FRANÇAIS', 'FR'),
    Language('ARABIC | ﻋَﺮَﺑِﻲّ', 'AR'),
    Language('SPANISH | ESPAÑOL', 'ES'),
    Language('ITALIAN | ITALIANO', 'IT'),
  ];

  final List<String> menus = [
    'Snap',
    'Max',
    'Help',
    'Blog',
    'Login',
  ];

  @override
  void initState() {
    super.initState();
    selectedLanguage = languages[0];
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
    });
  }

  void _onLanguageChanged(Language? newLanguage) {
    setState(() {
      selectedLanguage = newLanguage;
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
          _buildBodyContainer(),
          if (isMenuOpen)
            MenuWidget(
              isMenuOpen: isMenuOpen,
              toggleMenu: _toggleMenu,
              selectedLanguage: selectedLanguage!,
              onLanguageChanged: _onLanguageChanged,
              languages: languages,
              menus: menus,
            ),
        ],
      ),
    );
  }

  Widget _buildBodyContainer() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Center(
        child: Text(
          'Body Content',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
