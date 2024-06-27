import 'package:flutter/material.dart';

import '../models/languages.dart';

class MenuWidget extends StatefulWidget {
  final bool isMenuOpen;
  final VoidCallback toggleMenu;
  final Language selectedLanguage;
  final ValueChanged<Language?> onLanguageChanged;
  final List<Language> languages;
  final List<String> menus;

  const MenuWidget({
    super.key,
    required this.isMenuOpen,
    required this.toggleMenu,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.languages,
    required this.menus,
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

  @override
  void initState() {
    super.initState();
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
          // constraints: const BoxConstraints(minHeight: 500),
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // const SizedBox(height: 16),
                _buildLanguageDropdown(),
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

  Widget _buildLanguageDropdown() {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: DropdownButtonFormField<Language>(
            elevation: 0,
            icon: const SizedBox.shrink(),
            isDense: false,
            isExpanded: true,
            alignment: AlignmentDirectional.center,
            dropdownColor: Colors.white,
            value: widget.selectedLanguage,
            decoration: const InputDecoration(
                enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
            )),
            onChanged: (Language? newValue) {
              setState(() {
                widget.onLanguageChanged(newValue);
              });
            },
            items: widget.languages
                .map<DropdownMenuItem<Language>>((Language value) {
              return DropdownMenuItem<Language>(
                value: value,
                child: Text(
                  value.fullName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onTap: () {
              setState(() {
                isDropdownOpened = !isDropdownOpened;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  isDropdownOpened = !isDropdownOpened;
                });
              });
            },
            selectedItemBuilder: (context) {
              return widget.languages.map<Widget>((Language value) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(4)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        value.displayCode,
                        style: const TextStyle(color: Colors.black),
                      ),
                      const Icon(Icons.arrow_drop_down, color: Colors.black),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        );
      },
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < widget.menus.length; ++i) {
      listItems.add(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Text(
                  widget.menus[i],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    // fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              if (widget.menus[i] == 'Snap' || widget.menus[i] == 'Max')
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
}
