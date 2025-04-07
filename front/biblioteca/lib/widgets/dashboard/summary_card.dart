import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int? count;
  final IconData? icon;
  final Color color;
  final VoidCallback? onPressed;

  const SummaryCard({
    super.key,
    required this.title,
    this.count,
    this.icon,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: 200,
        height: 100,
        child: Card(
          color: color,
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (count != null)
                    Text(
                      count.toString(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )
                  else if (icon != null)
                    Icon(icon, size: 38, color: Colors.white),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
