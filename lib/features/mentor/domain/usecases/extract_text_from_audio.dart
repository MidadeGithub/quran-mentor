import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_mentor/core/api/base_response.dart';
import 'package:quran_mentor/core/error/failures.dart';
import 'package:quran_mentor/core/usecases/usecase.dart';
import 'package:quran_mentor/features/mentor/domain/repositories/mentor_repository.dart';

class ExtractTextFromAudio extends UseCase<BaseResponse, ExtractTextFromAudioParams> {
  final MentorRepository repository;

  ExtractTextFromAudio(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(ExtractTextFromAudioParams params) {
    return repository.extractTextFromAudio(params.filePath);
  }
}

class ExtractTextFromAudioParams extends Equatable {
  final String filePath;

  const ExtractTextFromAudioParams({required this.filePath});
  @override
  List<Object> get props => [filePath];
}
