import 'package:flutter/material.dart';

class DefaultDialogItem extends StatelessWidget {
  final String label;
  final BuildContext context;

  const DefaultDialogItem({
    super.key,
    required this.label,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.normal,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
