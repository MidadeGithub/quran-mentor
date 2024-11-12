import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quran_mentor/config/locale/app_localizations.dart';
import 'package:quran_mentor/core/utils/app_strings.dart';

import 'package:quran_mentor/core/utils/media_query_values.dart';
import 'package:quran_mentor/features/splash/presentation/cubit/locale_cubit.dart';

import 'app_colors.dart';

const testPersonImage =
    'https://t3.ftcdn.net/jpg/02/99/04/20/360_F_299042079_vGBD7wIlSeNl7vOevWHiL93G4koMM967.jpg';
const courseItemTest =
    'https://www.classcentral.com/report/wp-content/uploads/2022/05/Adobe-XD-BCG-Banner.png';

class Constants {
  static getDefaultPadding(BuildContext context) {
    return EdgeInsets.only(
        right: context.width * 0.04,
        left: context.width * 0.04,
        top: context.width * 0.05);
  }

  static getDefaultMargin(BuildContext context) {
    return EdgeInsets.all(context.width * 0.05);
  }

  static dynamic decodeJson(Response<dynamic> response) {
    var responseJson = jsonDecode(response.data.toString());
    return responseJson;
  }

  static void showToast(
      {required String message, Color? color, ToastGravity? gravity}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: color ?? AppColors.primaryColor,
    );
  }

  static void showError(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    // fontFamily: AppStrings.almaraiFontFamily,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text(
                      AppLocalizations.of(context)!.translate('ok')!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontFamily: AppStrings.almaraiFontFamily,
                          fontSize: 14),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              )
            : Directionality(
                textDirection:
                    context.read<LocaleCubit>().currentLangCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  alignment: Alignment.center,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  titleTextStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    // fontFamily: AppStrings.almaraiFontFamily,
                  ),
                  title: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      // fontFamily: AppStrings.almaraiFontFamily,
                    ),
                  ),
                  actions: <Widget>[
                    SizedBox(
                      width: context.width * 0.25,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: AppColors.primaryColor,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                // fontFamily: AppStrings.almaraiFontFamily,
                                fontSize: 14),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                              AppLocalizations.of(context)!.translate('ok')!)),
                    ),
                  ],
                ),
              ));
  }

  static PreferredSize getLightAppBar(BuildContext context,
      {String? title,
      bool moreHeight = true,
      Color? backgroundColor,
      Color? titleColor,
      Color? leadingColor,
      bool showAnimatedAppBar = true,
      Function()? onTap,
      final double? height,
      final List<Widget>? actions,
      final bool haveLeading = true}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        moreHeight ? 50 : height ?? 50,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: AppBar(
          toolbarHeight: moreHeight ? 50 : height ?? 30,
          backgroundColor: backgroundColor ?? Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            statusBarIconBrightness: Brightness.dark,
          ),
          leading: haveLeading && Platform.isIOS
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: leadingColor ?? AppColors.secondaryColor),
                  onPressed: onTap ?? () => Navigator.pop(context),
                )
              : haveLeading && Platform.isAndroid
                  ? IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: leadingColor ?? AppColors.secondaryColor),
                      onPressed: onTap ?? () => Navigator.pop(context),
                    )
                  : null,
          title: Text(title ?? "",
              style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    color: titleColor ?? AppColors.secondaryColor,
                  )),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: context.width * 0.06,
            color: AppColors.secondaryColor,
            fontWeight: FontWeight.bold,
          ),
          actions: actions,
          // systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        ),
      ),
    );
  }

  // static Future<void> openUrl(String url) async {
  //   if (!await launchUrl(Uri.parse(url),
  //       mode: LaunchMode.externalApplication)) {
  //     throw 'Could not launch $url';
  //   }
  // }

  static PreferredSize getDarkAppBar(BuildContext context,
      {required String title,
      bool moreHeight = true,
      Color? backgroundColor,
      Color? titleColor,
      Color? leadingColor,
      Function()? onTap,
      final double? height,
      final List<Widget>? actions,
      final bool haveLeading = true}) {
    return PreferredSize(
      preferredSize: Size.fromHeight(
        moreHeight ? 50 : height ?? 50,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: AppBar(
          toolbarHeight: moreHeight ? 50 : height ?? 30,
          backgroundColor: backgroundColor ?? Colors.white,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: AppColors.primaryColor,
            statusBarIconBrightness: Brightness.light,
          ),
          leading: haveLeading && Platform.isIOS
              ? IconButton(
                  icon: Icon(Icons.arrow_back_ios,
                      color: leadingColor ?? AppColors.primaryColor),
                  onPressed: onTap ?? () => Navigator.pop(context),
                )
              : haveLeading && Platform.isAndroid
                  ? IconButton(
                      icon: Icon(Icons.arrow_back,
                          color: leadingColor ?? AppColors.primaryColor),
                      onPressed: onTap ?? () => Navigator.pop(context),
                    )
                  : null,
          title: Text(title,
              style: Theme.of(context).appBarTheme.titleTextStyle!.copyWith(
                    color: titleColor ?? AppColors.primaryColor,
                  )),
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontSize: context.width * 0.06,
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
          ),
          actions: actions,
          // systemOverlayStyle: Theme.of(context).appBarTheme.systemOverlayStyle,
        ),
      ),
    );
  }

  static void showDefaultDialog({
    required BuildContext context,
    required String message,
    VoidCallback? onOkPressed,
    VoidCallback? onCancelPressed,
  }) {
    showDialog(
        context: context,
        builder: (BuildContext context) => Platform.isIOS
            ? CupertinoAlertDialog(
                title: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: AppStrings.interFontFamily,
                  ),
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: onOkPressed ?? () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.translate('ok')!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppStrings.interFontFamily,
                          fontSize: 14),
                    ),
                  ),
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed:
                        onCancelPressed ?? () => Navigator.of(context).pop(),
                    child: Text(
                      AppLocalizations.of(context)!.translate('cancel')!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: AppStrings.interFontFamily,
                          fontSize: 14),
                    ),
                  ),
                ],
              )
            : Directionality(
                textDirection:
                    context.read<LocaleCubit>().currentLangCode == 'ar'
                        ? TextDirection.rtl
                        : TextDirection.ltr,
                child: AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  alignment: Alignment.center,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  titleTextStyle: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontFamily: AppStrings.interFontFamily,
                  ),
                  title: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 16,
                      fontFamily: AppStrings.interFontFamily,
                    ),
                  ),
                  actions: <Widget>[
                    SizedBox(
                      width: context.width * 0.25,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppStrings.interFontFamily,
                              fontSize: 14),
                        ),
                        onPressed:
                            onOkPressed ?? () => Navigator.of(context).pop(),
                        child: Text(
                          AppLocalizations.of(context)!.translate('ok')!,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: context.width * 0.25,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: AppColors.primaryColor,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: AppStrings.interFontFamily,
                              fontSize: 14),
                        ),
                        onPressed: onCancelPressed ??
                            () => Navigator.of(context).pop(),
                        child: Text(
                          AppLocalizations.of(context)!.translate('cancel')!,
                        ),
                      ),
                    ),
                  ],
                ),
              ));
  }
}
