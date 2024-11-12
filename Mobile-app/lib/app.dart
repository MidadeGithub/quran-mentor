import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quran_mentor/config/routes/app_route.dart';
import 'package:quran_mentor/features/mentor/presentation/cubit/mentor_cubit.dart';
import 'package:quran_mentor/features/splash/presentation/cubit/locale_cubit.dart';

import 'config/locale/app_localizations_setup.dart';
import 'config/theme/light_theme.dart';
import 'injection_container.dart' as di;

class MentorApp extends StatefulWidget {
  const MentorApp({super.key});

  @override
  State<MentorApp> createState() => _MentorAppState();
}

class _MentorAppState extends State<MentorApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<LocaleCubit>()..getSavedLang(),
        ),
        BlocProvider(create: (_) => di.sl<MentorCubit>()),
      ],
      child: BlocBuilder<LocaleCubit, LocaleState>(
        buildWhen: (previousState, currentState) =>
            previousState != currentState,
        builder: (_, localeState) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            // ignore: deprecated_member_use
            useInheritedMediaQuery: true,
            onGenerateRoute: AppRoutes.onGenerateRoute,
            theme: AppTheme.appLightTheme(context),
            supportedLocales: AppLocalizationsSetup.supportedLocales,
            localizationsDelegates:
                AppLocalizationsSetup.localizationsDelegates,
            localeResolutionCallback:
                AppLocalizationsSetup.localeResolutionCallback,
            locale: localeState.locale,
          );
        },
      ),
    );
  }
}
