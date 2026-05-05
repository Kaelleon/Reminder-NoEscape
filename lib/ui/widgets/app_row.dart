import 'package:flutter/material.dart';

class AppRow extends StatelessWidget
{
  final IconData icon;
  final Color iconColor;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final bool iconContainer;

  const AppRow
  ({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    this.subtitle,
    this.trailing,
    this.iconContainer = false,
  });

  @override
  Widget build(BuildContext context)
  {
    return Padding
    (
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row
      (
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          //icono o contenedor
          iconContainer
          ? Container
            (
              width: 42,
              height: 42,
              decoration: BoxDecoration
              (
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            )
          : Icon(icon, color: iconColor, size: 22),

          const SizedBox(width: 12),

          //titulo o etiqueta
          Expanded
          (
            child: Column
            (
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Text
                (
                  label,
                  style: const TextStyle
                  (
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text
                  (
                    subtitle!,
                    style: const TextStyle
                    (
                      fontSize: 13,
                      color: Color.fromARGB(255, 119, 119, 119),
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}