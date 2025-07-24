import 'package:flutter/material.dart';

class SensorCardWidget extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final TextStyle? valueStyle;
  final String? description;

  const SensorCardWidget({
    Key? key,
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    this.valueStyle,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(value,
                style: valueStyle ??
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(color: Colors.grey)),
            if (description != null) ...[
              const SizedBox(height: 6),
              Text(
                description!,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
