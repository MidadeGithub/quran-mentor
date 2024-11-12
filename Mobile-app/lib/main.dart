import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:quran_mentor/app.dart';
import 'package:quran_mentor/bloc_observer.dart';

import 'core/api/cache_helper.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  CacheHelper.init();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarDividerColor: Colors.white,
    systemNavigationBarColor: Colors.white,
  ));
  Bloc.observer = AppObserver();

  runApp(Phoenix(child: const MentorApp()));
}
