import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import '../utils/hex_color.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final double borderRadius;

  const CustomCheckbox({
    Key? key,
    required this.value,
    required this.onChanged,
    this.borderRadius = 30.0,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    isChecked = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
        widget.onChanged?.call(isChecked);
      },
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        width: 24.0,
        height: 24.0,
        decoration: BoxDecoration(
          color: isChecked ? AppColors.accentColor : null,
          border: Border.all(
            width: 2.0,
            color: HexColor('#E3E9ED'),
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: isChecked
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 16.0,
              )
            : null,
      ),
    );
  }
}
