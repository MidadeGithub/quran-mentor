import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quran_mentor/core/utils/app_strings.dart';

const imagePath = 'assets/images';
const videosPath = 'assets/videos';
const iconsPath = 'assets/icons';
const localImagesPath = 'assets/local_images';
const localVideosPath = 'assets/local_videos';

class AppAssets {
  //images
  static const String splash = '$imagePath/splash.png';
  static const String library = '$imagePath/share.png';
  static const String loadingAnimatedGif = 'assets/loading-animated.gif';
  static const String appLogo2D = '$imagePath/Logo_2D.png';
  static const String whiteImage = '$imagePath/white_image.png';
  static const String osoulCenterLogo = '$imagePath/OsoulCenter-logo.png';
  static const String rassolAllahLogo = '$imagePath/RassolAllah-logo.png';
  static const String backgroundShape = '$imagePath/background-shape.png';
  static const String renderActive = '$imagePath/render-active.png';
  static const String mobileRessActive = '$imagePath/mobile-ress-active.png';
  static const String youtubeRessActive = '$imagePath/youtube-ress-active.png';

//videos
  static const String splashVideo = '$videosPath/splash_video.mp4';

//icons
//1
  static const String libraryActiveIcon = '$imagePath/library-active.png';
  static const String audioFileActiveIcon = '$imagePath/upload-active.png';
  static const String recordingActiveIcon = '$imagePath/mic-active.png';
  static const String categoryActiveIcon = '$imagePath/shekh-active.png';
  //inactive
  static const String libraryInactiveIcon = '$imagePath/library-inactive.png';
  static const String audioFileInactiveIcon = '$imagePath/upload-inactive.png';
  static const String recordingInactiveIcon = '$imagePath/mic-inactive.png';
  static const String categoryInactiveIcon = '$imagePath/shekh-inactive.png';

  //fonlder icon
  static const String folderIcon = '$localImagesPath/folder-icon.png';

  //localImages
  static const String one = '$localImagesPath/folder-icon.png';
  static const String two = '$localImagesPath/2.png';
  static const String three = '$localImagesPath/3.png';
  static const String four = '$localImagesPath/4.png';
  static const String five = '$localImagesPath/5.png';
  static const String six = '$localImagesPath/6.png';
  static const String seven = '$localImagesPath/7.png';
  static const String eight = '$localImagesPath/8.png';
  static const String nine = '$localImagesPath/9.png';
  static const String ten = '$localImagesPath/10.png';
  static const String eleven = '$localImagesPath/11.png';
  static const String twelve = '$localImagesPath/12.png';
  static const String thirteen = '$localImagesPath/13.png';
  static const String sixteen = '$localImagesPath/16.png';
  static const String seventeen = '$localImagesPath/17.png';
  static const String eighteen = '$localImagesPath/18.png';
  static const String nineteen = '$localImagesPath/19.png';
  static const String twenty = '$localImagesPath/20.png';
  static const String twentyOne = '$localImagesPath/21.png';
  static const String twentyTwo = '$localImagesPath/22.png';
  static const String twentyThree = '$localImagesPath/23.png';
  static const String twentyFour = '$localImagesPath/24.png';
  static const String twentyFive = '$localImagesPath/25.png';
  static const String twentySix = '$localImagesPath/26.png';
  static const String twentySeven = '$localImagesPath/27.png';
  static const String twentyEight = '$localImagesPath/28.png';
  static const String twentyNine = '$localImagesPath/29.png';
  static const String thirty = '$localImagesPath/30.png';
  static const String thirtyOne = '$localImagesPath/31.png';
  static const String thirtyTwo = '$localImagesPath/32.png';
  static const String thirtyThree = '$localImagesPath/33.png';
  static const String thirtyFour = '$localImagesPath/34.png';

//localVideos

  //mobile
  static const String oneMobileVideo = '$localVideosPath/bg_video_mobile_1.mp4';
  static const String twoMobileVideo = '$localVideosPath/bg_video_mobile_2.mp4';
  static const String threeMobileVideo =
      '$localVideosPath/bg_video_mobile_3.mp4';
  static const String fourMobileVideo =
      '$localVideosPath/bg_video_mobile_4.mp4';
  static const String fiveMobileVideo =
      '$localVideosPath/bg_video_mobile_5.mp4';

  //youtube
  static const String oneYoutubeVideo =
      '$localVideosPath/bg_video_youtube_1.mp4';
  static const String twoYoutubeVideo =
      '$localVideosPath/bg_video_youtube_2.mp4';
  static const String threeYoutubeVideo =
      '$localVideosPath/bg_video_youtube_3.mp4';
  static const String fourYoutubeVideo =
      '$localVideosPath/bg_video_youtube_4.mp4';
  static const String fiveYoutubeVideo =
      '$localVideosPath/bg_video_youtube_5.mp4';

  static localImages() => [
        one,
        two,
        three,
        four,
        five,
        six,
        seven,
        eight,
        nine,
        ten,
        eleven,
        twelve,
        thirteen,
        sixteen,
        seventeen,
        eighteen,
        nineteen,
        twenty,
        twentyOne,
        twentyTwo,
        twentyThree,
        twentyFour,
        twentyFive,
        twentySix,
        twentySeven,
        twentyEight,
        twentyNine,
        thirty,
        thirtyOne,
        thirtyTwo,
        thirtyThree,
        thirtyFour,
      ];

  static localVideos() => [
        oneMobileVideo,
        twoMobileVideo,
        threeMobileVideo,
        fourMobileVideo,
        fiveMobileVideo,
      ];

  static localYoutubeVideos() => [
        oneYoutubeVideo,
        twoYoutubeVideo,
        threeYoutubeVideo,
        fourYoutubeVideo,
        fiveYoutubeVideo,
      ];

  static Future<String> getDownloadedVideoPath(
      int videoNumber, Orientation orientation) async {
    return "${(await AppStrings.getAppDirectoryPath()).path}/${orientation == Orientation.portrait ? 'bg_video_mobile_$videoNumber.mp4' : 'bg_video_youtube_$videoNumber.mp4'}";
  }

  static Future<bool> checkIfVideoDownloaded(int videoNumber) async {
    final path = await AppAssets.getDownloadedVideoPath(
        videoNumber, Orientation.portrait);
    final result = File(path).existsSync();
    return Future.value(result);
  }
}
