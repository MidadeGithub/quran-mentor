import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:quran_mentor/core/api/api_consumer.dart';
import 'package:quran_mentor/core/api/app_interceptors.dart';
import 'package:quran_mentor/core/api/dio_consumer.dart';
import 'package:quran_mentor/core/network/network_info.dart';
import 'package:quran_mentor/features/mentor/mentor_injection_feature.dart';
import 'package:quran_mentor/features/mentor/presentation/cubit/mentor_cubit.dart';
import 'package:quran_mentor/features/splash/data/datasources/lang_local_data_source.dart';
import 'package:quran_mentor/features/splash/data/repositories/lang_repository_impl.dart';
import 'package:quran_mentor/features/splash/domain/repositories/lang_repository.dart';
import 'package:quran_mentor/features/splash/domain/usecases/change_lang.dart';
import 'package:quran_mentor/features/splash/domain/usecases/get_saved_lang.dart';
import 'package:quran_mentor/features/splash/presentation/cubit/locale_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt sl = GetIt.instance;
Future<void> init() async {
  // Blocs
  sl.registerFactory<LocaleCubit>(
      () => LocaleCubit(getSavedLangUseCase: sl(), changeLangUseCase: sl()));

  // Use cases
  sl.registerLazySingleton<GetSavedLang>(
      () => GetSavedLang(langRepository: sl()));
  sl.registerLazySingleton<ChangeLang>(() => ChangeLang(langRepository: sl()));

  // Repository
  sl.registerLazySingleton<LangRepository>(
      () => LangRepositoryImpl(langLocalDataSource: sl()));

  // Data sources
  sl.registerLazySingleton<LangLocalDataSource>(
    () => LangLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Features
  await mentorInjectoinFeature();

  //core
  sl.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(connectionChecker: sl()));
  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(client: sl()));
  sl.registerLazySingleton(() => LogInterceptor(
      responseBody: true,
      error: true,
      requestHeader: true,
      responseHeader: true,
      request: true,
      requestBody: true));
  sl.registerLazySingleton(() => AppIntercepters(langLocalDataSource: sl()));
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
