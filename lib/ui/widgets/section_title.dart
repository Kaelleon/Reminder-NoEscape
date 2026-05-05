import 'package:flutter/material.dart';

//bara del encabezado
class SectionTitle extends StatelessWidget
{
  final String label;
  final Color color;

  const SectionTitle({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context)
  {
    return Align
    (
      alignment: Alignment.centerLeft,
      child: Row
      (
        children:
        [
          Container
          (
            width: 4,
            height: 18,
            decoration: BoxDecoration
            (
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),

          Text
          (
            label,
            style: const TextStyle
            (
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
