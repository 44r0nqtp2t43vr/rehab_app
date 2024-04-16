import 'package:flutter/material.dart';

class PhysicianNumberCard extends StatelessWidget {
  final int number;
  final String label;

  const PhysicianNumberCard(
      {super.key, required this.number, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xff128BED),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "$number",
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontFamily: 'Sailec Bold',
                  fontSize: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Sailec Light',
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
