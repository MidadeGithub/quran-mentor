import 'package:dartz/dartz.dart';
import 'package:quran_mentor/core/error/failures.dart';
import 'package:quran_mentor/core/usecases/usecase.dart';

import '../repositories/lang_repository.dart';

class GetSavedLang implements UseCase<String, NoParams> {
  final LangRepository langRepository;

  GetSavedLang({required this.langRepository});

  @override
  Future<Either<Failure, String>> call(NoParams params) async =>
      await langRepository.getSavedLang();
}
