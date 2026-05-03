import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget
{
  final String imagePath;
  final String title;
  final String subtitle;

  const EmptyState
  ({
    super.key, 
    required this.imagePath, 
    required this.title, 
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context)
  {
    return Center
    (
      child: Padding
      (
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column
        (
          mainAxisAlignment: MainAxisAlignment.center,
          children: 
          [
            Image.asset(imagePath, height: 150),
            const SizedBox(height: 30),
            Text
            (
              title,
              textAlign: TextAlign.center,
              style: const TextStyle
              (
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Text
            (
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle
              (
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}