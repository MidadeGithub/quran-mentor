import 'package:flutter/material.dart';
import 'package:quran_mentor/core/utils/constants.dart';
import '../utils/app_colors.dart';

class ScreenContainer extends StatelessWidget {
  final Widget child;
  final PreferredSize? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool havePadding;
  final Color? backgroundColor;

  const ScreenContainer(
      {Key? key,
      required this.child,
      this.appBar,
      this.bottomNavigationBar,
      this.floatingActionButton,
      this.havePadding = true,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: AppColors.primaryColor,
        child: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
              child: Scaffold(
                appBar: appBar,
                backgroundColor: backgroundColor ?? AppColors.backgroundColor,
                body: Padding(
                  padding: havePadding
                      ? Constants.getDefaultPadding(context)
                      : EdgeInsets.zero,
                  child: child,
                ),
                bottomNavigationBar: bottomNavigationBar,
                floatingActionButton: floatingActionButton,
              ),
            ),
          ),
        ));
  }
}
