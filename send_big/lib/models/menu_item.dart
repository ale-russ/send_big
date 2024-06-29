import 'package:flutter/material.dart';

class MenuItem {
  final String? label;
  // final VoidCallback onTap;
  final bool showNewTag;

  MenuItem({
    required this.label,
    // required this.onTap,
    this.showNewTag = false,
  });
}
