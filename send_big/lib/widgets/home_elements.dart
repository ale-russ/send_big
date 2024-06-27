import 'package:flutter/material.dart';
import 'package:send_big/widgets/moto.dart';
import 'package:send_big/widgets/upload_files.dart';

class HomeElements extends StatelessWidget {
  const HomeElements({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [
            Motto(),
            SizedBox(height: 32),
            UploadFiles(),
          ],
        ));
  }
}
