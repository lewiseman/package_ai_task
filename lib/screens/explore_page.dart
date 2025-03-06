import 'package:flutter/material.dart';

class ExplorePage extends StatelessWidget {
  const ExplorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 110),
        child: Image.asset(
          'assets/images/coming_soon.png',
          fit: BoxFit.cover,
          width: 180,
        ),
      ),
    );
  }
}
