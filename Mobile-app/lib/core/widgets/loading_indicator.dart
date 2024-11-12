import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../utils/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;
  const LoadingIndicator({Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitCircle(
        color: AppColors.loadingColor,
        size: size ?? 35,
      ),
      //change shape
      // SpinKitFadingCircle(
      //   color: AppColors.loadingColor,
      //   size: size ?? 35,
      // ),
      //change shape

      //     SpinKitDoubleBounce(
      //   color: AppColors.loadingColor,
      //   size: size ?? 35,
      // ),
    );
  }
}
