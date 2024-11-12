import 'package:flutter/material.dart';
import 'package:quran_mentor/core/utils/hex_color.dart';
import '../utils/media_query_values.dart';
import '../utils/app_colors.dart';

class DefaultButton extends StatelessWidget {
  final String btnLbl;
  final bool enableMargin;
  final VoidCallback onPressed;
  final BorderRadiusGeometry borderRadius;
  final TextStyle? style;
  final double? height;
  final double? width;
  final Color? buttonColor;
  final Color? disableColor;
  final bool isDisable;

  const DefaultButton(
      {Key? key,
      required this.btnLbl,
      this.enableMargin = false,
      required this.onPressed,
      this.borderRadius = const BorderRadius.all(Radius.circular(24)),
      this.style,
      this.height,
      this.width,
      this.buttonColor,
      this.disableColor,
      this.isDisable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 50,
      width: width ?? context.width,
      margin: EdgeInsets.symmetric(horizontal: enableMargin ? 16 : 0),
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
            elevation: 0,
            backgroundColor: !isDisable
                ? buttonColor ?? AppColors.accentColor
                : HexColor('#ECF1F6'),
            shape: RoundedRectangleBorder(borderRadius: borderRadius)),
        onPressed: () => onPressed(),
        child: Text(
          btnLbl,
          style: style ??
              Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
