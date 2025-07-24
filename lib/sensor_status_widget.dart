import 'package:flutter/material.dart';

class SensorStatusWidget extends StatelessWidget {
  final String label;
  final bool ok;

  const SensorStatusWidget({Key? key, required this.label, required this.ok}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ok ? Icons.check_circle : Icons.error,
                color: ok ? Colors.green : Colors.red, size: 22),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        Text(
          ok ? 'OK' : 'ERROR',
          style: TextStyle(
            color: ok ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

