import 'package:flutter/material.dart';

class CampoObrigatorio extends StatelessWidget {
  const CampoObrigatorio({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label),
        const Text(' *' , style: TextStyle(color: Colors.red),),
      ],
    );
  }
}
