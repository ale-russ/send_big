import 'package:flutter/material.dart';

class Motto extends StatelessWidget {
  const Motto({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset(
            'assets/images/sendBig.png',
          ),
          const Text('Share large files up to 30GB for',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
          const Text('Free',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700)),
          const Text('Reliable Resumable Upload: Login, start',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
          const Text('your upload today & resume it tomorrow',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600))
        ],
      ),
    );
  }
}
