import 'package:flutter/material.dart';

class HourlyWeather extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyWeather(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                time,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 34,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                temp,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
