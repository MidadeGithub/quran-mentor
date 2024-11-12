import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/hex_color.dart';

class DefaultTextFormField extends StatefulWidget {
  final bool enabled;
  final String? initialValue;
  final String? hintTxt;
  final bool borderIsEnabled;
  final bool marginIsEnabled;
  final TextInputType? inputData;
  final bool isPassword;
  final double radius;
  final double? margin;
  final bool readOnly;
  final bool haveShadow;
  final String? Function(String?)? validationFunction;
  final dynamic Function(String?)? onChangedFunction;
  final ValueChanged<String>? onFieldSubmitted;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final Widget? suffix;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final Widget? prefix;
  final Widget? prefixIcon;
  final String? labelTxt;
  final bool expands;
  final TextEditingController? controller;
  final Color? unfocusColor;
  final Color? hintColor;
  final Color? focusColor;
  final Color? filledColor;
  final Color? borderColor;
  final bool filled;
  final List<TextInputFormatter>? inputFormatters;
  final AutovalidateMode autovalidateMode;
  final TextInputAction? textInputAction;
  final String? helperText;
  final TextStyle? hintTextStyle;
  final Function()? onSuffixIconPressed;
  final FocusNode? focusNode;
  final bool withTitle;
  final String? title;

  const DefaultTextFormField({
    Key? key,
    this.hintTxt,
    this.onFieldSubmitted,
    this.inputData,
    this.borderIsEnabled = true,
    this.isPassword = false,
    this.readOnly = false,
    this.validationFunction,
    this.onChangedFunction,
    this.initialValue,
    this.suffixIcon,
    this.radius = 24,
    this.maxLength,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.enabled = true,
    this.maxLines,
    this.minLines,
    this.expands = false,
    this.labelTxt,
    this.prefix,
    this.unfocusColor,
    this.hintColor,
    this.focusColor,
    this.suffix,
    this.filled = true,
    this.marginIsEnabled = false,
    this.filledColor,
    this.prefixIcon,
    this.controller,
    this.inputFormatters,
    this.textInputAction,
    this.onEditingComplete,
    this.onTap,
    this.helperText,
    this.borderColor,
    this.margin,
    this.haveShadow = false,
    this.hintTextStyle,
    this.onSuffixIconPressed,
    this.focusNode,
    this.withTitle = false,
    this.title,
  }) : super(key: key);

  @override
  State<DefaultTextFormField> createState() => _DefaultTextFormFieldState();
}

class _DefaultTextFormFieldState extends State<DefaultTextFormField> {
  bool _obsecureText = true;

  Widget _buildTextFormField() {
    return StatefulBuilder(
        builder: (context, setState) => TextFormField(
              onFieldSubmitted: widget.onFieldSubmitted,
              onEditingComplete: widget.onEditingComplete,
              onTap: widget.onTap,
              readOnly: widget.readOnly,
              textInputAction: widget.textInputAction,
              autovalidateMode: widget.autovalidateMode,
              inputFormatters: widget.inputFormatters,
              expands: widget.expands,
              controller: widget.controller,
              enabled: widget.enabled,
              maxLines: widget.isPassword ? 1 : widget.maxLines,
              minLines: widget.minLines,
              maxLength: widget.maxLength,
              initialValue: widget.initialValue,
              style: Theme.of(context).textTheme.labelSmall,
              focusNode: widget.focusNode,
              decoration: InputDecoration(
                helperText: widget.helperText,
                filled: widget.filled ? true : false,
                fillColor: widget.filledColor ?? Colors.transparent,
                suffix: widget.suffix,
                suffixIcon: widget.isPassword
                    ? GestureDetector(
                        onTap: () {
                          setState(() {
                            _obsecureText = !_obsecureText;
                          });
                        },
                        child: Icon(
                          _obsecureText
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          color: AppColors.secondaryColor,
                          size: 18,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: widget.suffixIcon,
                      ),
                border: !widget.borderIsEnabled
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.radius),
                        borderSide: BorderSide(
                            color: widget.borderColor ?? Colors.grey.shade400)),
                enabledBorder: !widget.borderIsEnabled
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderRadius: BorderRadius.circular(widget.radius),
                        borderSide: BorderSide(
                            color: widget.borderColor ?? Colors.grey.shade400)),
                focusedBorder: !widget.borderIsEnabled
                    ? InputBorder.none
                    : OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.grey.shade400, width: 2),
                        borderRadius: BorderRadius.circular(widget.radius),
                      ),
                prefix: widget.prefix,
                prefixIcon: widget.prefixIcon,
                hintStyle: widget.hintTextStyle ??
                    Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: AppColors.hintColor, fontSize: 14),
                hintText: widget.hintTxt,
                labelText: widget.labelTxt,
              ),
              keyboardType: widget.inputData,
              obscureText: widget.isPassword ? _obsecureText : false,
              validator: widget.validationFunction,
              onChanged: widget.onChangedFunction,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.haveShadow
          ? BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                // offset: Off
              )
            ])
          : null,
      margin: EdgeInsets.symmetric(
          horizontal: widget.marginIsEnabled ? widget.margin ?? 16 : 0),
      child: widget.withTitle
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title ?? '',
                  style: TextStyle(color: HexColor('#78828A'), fontSize: 14),
                ),
                const SizedBox(
                  height: 5,
                ),
                _buildTextFormField(),
              ],
            )
          : _buildTextFormField(),
    );
  }
}
