import 'package:flutter/material.dart';

class Additionalweather extends StatelessWidget {
  final IconData icon;
  final String label;
  final String label1;
  const Additionalweather(
      {super.key,
      required this.icon,
      required this.label,
      required this.label1});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 35,
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          label1,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
