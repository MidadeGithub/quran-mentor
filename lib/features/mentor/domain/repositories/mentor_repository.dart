import 'package:dartz/dartz.dart';
import 'package:quran_mentor/core/api/base_response.dart';
import 'package:quran_mentor/core/error/failures.dart';

abstract class MentorRepository {
  Future<Either<Failure, BaseResponse>> extractTextFromAudio(String filePath);
  Future<Either<Failure, BaseResponse>> analyzeExtractedText(String text);
}
