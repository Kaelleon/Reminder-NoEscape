import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget
{
  final Widget child;

  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context)
  {
    return Container
    (
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration
      (
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child,
    );
  }
}