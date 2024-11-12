import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quran_mentor/config/locale/app_localizations.dart';

class DefaultBackButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;
  const DefaultBackButton({
    super.key,
    this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed ?? () => Navigator.of(context).pop(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Icon(
          AppLocalizations.of(context)!.isArLocale
              ? Icons.arrow_forward_ios
              : Icons.arrow_back_ios,
          color: color ?? Colors.black,
        ),
      ),
    );
  }
}
