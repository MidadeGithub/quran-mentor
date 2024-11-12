import 'package:flutter/material.dart';

class DividerItem extends StatelessWidget {
  const DividerItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20, // Adjust height as needed
      child: Divider(
        color: Colors.grey.shade400,
        height: 1,
      ),
    );
  }
}
