// import 'package:flutter/material.dart';

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> with SingleTickerProviderStateMixin {
//   bool isMenuOpen = false;

//   final menus = [
//     'EN',
//     'Snap',
//     'Max',
//     'Help',
//     'Blog',
//     'Login',
//   ];

//   late AnimationController _controller;
//   late Animation<Offset> _slideAnimation;
//   late Animation<double> _opacityAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );

//     _slideAnimation = Tween<Offset>(
//       begin: const Offset(0, -1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));

//     _opacityAnimation = Tween<double>(
//       begin: 0,
//       end: 1,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   void _toggleMenu() {
//     setState(() {
//       isMenuOpen = !isMenuOpen;
//       if (isMenuOpen) {
//         _controller.forward();
//       } else {
//         _controller.reverse();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Image.asset(
//               'assets/images/sendBig.png',
//               width: 160,
//             ),
//             IconButton(onPressed: _toggleMenu, icon: const Icon(Icons.menu))
//           ],
//         ),
//       ),
//       body: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 4),
//         color: Colors.white,
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             _buildBodyContainer(),
//             _buildAnimatedContent(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAnimatedContent() {
//     return SlideTransition(
//       position: _slideAnimation,
//       child: FadeTransition(
//         opacity: _opacityAnimation,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 16),
//             ..._buildListItems(),
//             Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                 color: Colors.green,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Text(
//                 'Sign Up',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               alignment: Alignment.center,
//               decoration: BoxDecoration(
//                   color: Colors.red, borderRadius: BorderRadius.circular(8)),
//               child: const Text(
//                 'Report Files',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w500,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             const Spacer(),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Widget> _buildListItems() {
//     final listItems = <Widget>[];
//     for (var i = 0; i < menus.length; ++i) {
//       listItems.add(
//         Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
//           child: Text(
//             menus[i],
//             textAlign: TextAlign.center,
//             style: const TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//         ),
//       );
//     }
//     return listItems;
//   }

//   Widget _buildBodyContainer() {
//     return Container(
//       color: Colors.grey,
//       padding: const EdgeInsets.all(16),
//       child: const Center(
//         child: Text(
//           'Body Content',
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with SingleTickerProviderStateMixin {
  bool isMenuOpen = false;
  String selectedLanguage = 'EN';

  final languages = ['EN', 'FR', 'ES', 'DE', 'JP'];
  final menus = [
    'Snap',
    'Max',
    'Help',
    'Blog',
    'Login',
  ];

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    setState(() {
      isMenuOpen = !isMenuOpen;
      if (isMenuOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'assets/images/sendBig.png',
              width: 160,
            ),
            IconButton(
              onPressed: _toggleMenu,
              icon: const Icon(Icons.menu),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          _buildBodyContainer(),
          if (isMenuOpen) _buildAnimatedContent(),
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

  Widget _buildAnimatedContent() {
    return FadeTransition(
      opacity: _opacityAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                _buildLanguageDropdown(),
                ..._buildListItems(),
                Container(
                  width: double.infinity,
                  color: Colors.green,
                  alignment: Alignment.center,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: Colors.red,
                  alignment: Alignment.center,
                  child: const Text(
                    'Report Files',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
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
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: DropdownButtonFormField<String>(
            value: selectedLanguage,
            onChanged: (String? newValue) {
              setState(() {
                selectedLanguage = newValue!;
              });
            },
            items: languages.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
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
          ),
        );
      },
    );
  }

  List<Widget> _buildListItems() {
    final listItems = <Widget>[];
    for (var i = 0; i < menus.length; ++i) {
      listItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
          child: Text(
            menus[i],
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }
    return listItems;
  }
}
