abstract class ConstantsCommands {
  static getVideoWithAudioCommand({
    required String inputPath,
    required String audioPath,
    required String outputVideoPath,
    bool isYoutubeStyle = false,
    bool isTiktokStyle = true,
    bool isHighResolution = true,
  }) {
    String highYoutubeResolution = '1280x720';
    String lowYoutubeResolution = '640x360';
    String highTiktokResolution = '720x1280';
    String lowTiktokResolution = '360x640';
    String resolution = isHighResolution
        ? isYoutubeStyle
            ? highYoutubeResolution
            : highTiktokResolution
        : isYoutubeStyle
            ? lowYoutubeResolution
            : lowTiktokResolution;

    return '-i $inputPath -i $audioPath -map 0:v -map 1:a -c:v copy -c:a aac -shortest -s $resolution $outputVideoPath';
  }

  static String getVideWithOverlayImageCommand({
    required String videoPath,
    required String textScreenShotPath,
    required String shikhScreenShotPath,
    required String ctegoryScreenShotPath,
    required String outputVideoPath,
    int imageOverlayX = -450,
    int imageOverlayY = 250,
    bool isYoutubeStyle = false,
    bool isTiktokStyle = true,
    bool isHighResolution = true,
  }) {
    // String imageText1 = imagePath;
    // String imageText2 = imagePath;
    String highYoutubeResolution = '1280x720';
    String lowYoutubeResolution = '640x360';
    String highTiktokResolution = '720x1280';
    String lowTiktokResolution = '360x640';
    String resolution = isHighResolution
        ? isYoutubeStyle
            ? highYoutubeResolution
            : highTiktokResolution
        : isYoutubeStyle
            ? lowYoutubeResolution
            : lowTiktokResolution;
    String shikhNamePosition =
        '[v2][3:v]overlay=main_w/7.4:main_h-overlay_h-(main_h/2.5)';
    String categoryNamePosition =
        '[v1][2:v]overlay=main_w/1.8:main_h-overlay_h-(main_h/1.83)[v2]';
    String middleTextPosition =
        '[0:v][1:v]overlay=(main_w-overlay_w)/1.95:(main_h-overlay_h)/1.95[v1]';

    return '-i $videoPath -i $textScreenShotPath -i $ctegoryScreenShotPath -i $shikhScreenShotPath -filter_complex "$middleTextPosition;$categoryNamePosition;$shikhNamePosition" -c:a copy -s $resolution $outputVideoPath';
  }

  static getImageWithAudioCommand({
    required String audioPath,
    required String imagePath,
    required String outputVideoPath,
    bool isYoutubeStyle = true,
    bool isTiktokStyle = false,
    bool isHighResolution = true,
  }) {
    String highYoutubeResolution = '1280x720';
    String lowYoutubeResolution = '640x360';
    String highTiktokResolution = '720x1280';
    String lowTiktokResolution = '360x640';
    String resolution = isHighResolution
        ? isYoutubeStyle
            ? highYoutubeResolution // Horizontal (landscape)
            : highTiktokResolution
        : isYoutubeStyle
            ? lowYoutubeResolution // Horizontal (landscape)
            : lowTiktokResolution;

// Modify the resolution for vertical (portrait) video
// String resolution = isHighResolution
//     ? isYoutubeStyle
//         ? '720x1280'  // Vertical (portrait)
//         : '720x1280'
//     : isYoutubeStyle
//         ? '360x640'  // Vertical (portrait)
//         : '360x640';

    // return '-y -loop 1 -i $imagePath -i $audioPath -c:v mpeg4 -c:a aac -b:a 192k -pix_fmt yuv420p -shortest $outputVideoPath';

    return '-y -loop 1 -i $imagePath -i $audioPath -c:v mpeg4 -c:a aac -b:a 192k -pix_fmt yuv420p -shortest -s $resolution $outputVideoPath';
  }

  //! Audio
  static getConvertToMp3Command({
    required String inputPath,
    required String outputAudioPath,
  }) {
    //ffmpeg -i input.avi output.mp4
    return '-i $inputPath $outputAudioPath';
  }
}
