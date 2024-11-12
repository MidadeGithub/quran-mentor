import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppStrings {
  static const String noRouteFound = 'no Route Found';
  static const String locale = 'locale';
  static const String englishCode = 'en';
  static const String arabicCode = 'ar';
  static const String serverFailure = 'Server Failure';
  static const String cacheFailure = 'Cache Failure';
  static const String xRequested = 'X-Requested-With';
  static const String xmlHttpRequest = 'XMLHttpRequest';
  static const String pageUrl = 'page_url';
  static const String isFirstTime = 'isfirstTime';
  static const String contentType = 'Content-Type';
  static const String applicationJson = 'application/json';
  static const String bearer = 'Bearer ';
  static const String authorization = 'Authorization';
  static const String lang = 'APILang';
  static const String accessToken = 'accessToken';
  static const String errorDuringCommunication = "Error During Communication";
  static const String badRequest = "Bad Request";
  static const String unauthorized = "Unauthorized";
  static const String requestedInfoNotFound = "Requested Info Not Found";
  static const String conflictOccurred = "Conflict Occurred";
  static const String internalServerError = "Internal Server Error";
  static const String noInternetConnection = 'No Internet connection';
  static const String multipartFile = 'multipart/form-data';
  static const String plusJakartaSansFontFamily = 'Plus Jakarta Sans';
  static const String interFontFamily = 'Inter';
  static const String currentUserId = "currentUserId";

  static Future<Directory> getAppDirectoryPath() async {
    return Platform.isAndroid
        ? (await getExternalStorageDirectory())!
        : await getApplicationDocumentsDirectory();
  }
}
