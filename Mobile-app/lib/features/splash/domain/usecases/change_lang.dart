import 'package:dartz/dartz.dart';
import 'package:quran_mentor/core/error/failures.dart';
import 'package:quran_mentor/core/usecases/usecase.dart';

import '../repositories/lang_repository.dart';

class ChangeLang implements UseCase<bool, String> {
  final LangRepository langRepository;

  ChangeLang({required this.langRepository});

  @override
  Future<Either<Failure, bool>> call(String langCode) async =>
      await langRepository.changeLang(langCode: langCode);
}
