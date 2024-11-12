import 'dart:async';
import 'package:flutter/material.dart';
import 'package:quran_mentor/config/routes/app_route.dart';
import 'package:quran_mentor/core/animation/slide_in.dart';
import 'package:quran_mentor/core/api/cache_helper.dart';
import 'package:quran_mentor/core/utils/app_strings.dart';
import 'package:quran_mentor/core/utils/assets_manager.dart';
import 'package:quran_mentor/core/utils/media_query_values.dart';
import 'package:quran_mentor/core/widgets/screen_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer _timer;
  bool isFirstTime = CacheHelper.getData(key: AppStrings.isFirstTime) ?? true;

  _goNext() {
    Navigator.pushReplacementNamed(context, Routes.homeScreen);
  }

  _startDelay() => _timer = Timer(const Duration(seconds: 3), () => _goNext());

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget _buildBodyContent() {
    return Container(
        decoration: const BoxDecoration(
            // Background Image
            // image: DecorationImage(
            //   image: AssetImage(
            //     AppAssets.splashBackground,
            //   ),
            //   fit: BoxFit.cover,
            // ),
            ),
        child: Stack(
          children: [
            // app logo
            Center(
              child: Text("Quran Mentor",
                  style: TextStyle(
                    fontSize: context.height * 0.06,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
            )
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    return ScreenContainer(
        child: Scaffold(
      body: _buildBodyContent(),
    ));
  }
}
