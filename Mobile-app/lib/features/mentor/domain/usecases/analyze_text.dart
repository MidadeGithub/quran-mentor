import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:quran_mentor/core/api/base_response.dart';
import 'package:quran_mentor/core/error/failures.dart';
import 'package:quran_mentor/core/usecases/usecase.dart';
import 'package:quran_mentor/features/mentor/domain/repositories/mentor_repository.dart';

class AnalyzeText extends UseCase<BaseResponse, AnalyzeTextParams> {
  final MentorRepository repository;

  AnalyzeText(this.repository);

  @override
  Future<Either<Failure, BaseResponse>> call(AnalyzeTextParams params) {
    return repository.analyzeExtractedText(params.text);
  }
}

class AnalyzeTextParams extends Equatable {
  final String text;

  const AnalyzeTextParams({required this.text});
  @override
  List<Object> get props => [text];
}
