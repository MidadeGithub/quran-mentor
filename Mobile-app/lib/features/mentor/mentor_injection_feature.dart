import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:quran_mentor/features/mentor/data/datasources/mentor_remote_datasource.dart';
import 'package:quran_mentor/features/mentor/data/repositories/mentor_repository_impl.dart';
import 'package:quran_mentor/features/mentor/domain/repositories/mentor_repository.dart';
import 'package:quran_mentor/features/mentor/domain/usecases/analyze_text.dart';
import 'package:quran_mentor/features/mentor/domain/usecases/extract_text_from_audio.dart';
import 'package:quran_mentor/features/mentor/presentation/cubit/mentor_cubit.dart';
import 'package:quran_mentor/injection_container.dart';

Future<void> mentorInjectoinFeature() async {
  // Blocs
  sl.registerFactory<MentorCubit>(() => MentorCubit(sl(), sl()));

  // Use cases
  sl.registerLazySingleton<ExtractTextFromAudio>(
    () => ExtractTextFromAudio(sl()),
  );
  sl.registerLazySingleton<AnalyzeText>(() => AnalyzeText(sl()));

  // Repository
  sl.registerLazySingleton<MentorRepository>(
      () => MentorRepositoryImpl(sl()));

  // Data sources
  sl.registerLazySingleton<MentorRemoteDataSource>(
    () => MentorRemoteDataSourceImpl(apiConsumer: sl()),
  );
}
