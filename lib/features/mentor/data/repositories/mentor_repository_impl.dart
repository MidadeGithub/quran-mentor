import 'package:dartz/dartz.dart';
import 'package:quran_mentor/core/api/base_response.dart';
import 'package:quran_mentor/core/error/exceptions.dart';
import 'package:quran_mentor/core/error/failures.dart';
import 'package:quran_mentor/features/mentor/data/datasources/mentor_remote_datasource.dart';
import 'package:quran_mentor/features/mentor/domain/repositories/mentor_repository.dart';

class MentorRepositoryImpl implements MentorRepository {
  final MentorRemoteDataSource mentorRemoteDataSource;

  MentorRepositoryImpl(this.mentorRemoteDataSource);

  @override
  Future<Either<Failure, BaseResponse>> analyzeExtractedText(
      String text) async {
    try {
      final response = await mentorRemoteDataSource.analyzeExtractedText(text);

      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
      ));
    }
  }

  @override
  Future<Either<Failure, BaseResponse>> extractTextFromAudio(
      String filePath) async {
    try {
      final response =
          await mentorRemoteDataSource.extractTextFromAudio(filePath);
      return Right(response);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
      ));
    }
  }
}
