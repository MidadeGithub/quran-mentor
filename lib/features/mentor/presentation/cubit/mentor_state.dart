part of 'mentor_cubit.dart';

abstract class MentorState extends Equatable {
  const MentorState();

  @override
  List<Object> get props => [];
}

class MentorInitial extends MentorState {}

class QuranRecordingStarted extends MentorState {}

class QuranRecordingStopped extends MentorState {
  final String audioPath;

  const QuranRecordingStopped(
    this.audioPath,
  );

  @override
  List<Object> get props => [audioPath];
}

class QuranRecordingError extends MentorState {
  final String message;

  const QuranRecordingError(this.message);

  @override
  List<Object> get props => [message];
}

class QuranTextExtracted extends MentorState {
  final String text;

  const QuranTextExtracted(this.text);
}

class QuranAnalysisLoading extends MentorState {}

class QuranAnalysisCompleted extends MentorState {
  final AnalyzeResultModel result;

  const QuranAnalysisCompleted(this.result);

  @override
  List<Object> get props => [result];
}

class QuranAnalysisError extends MentorState {
  final String message;

  const QuranAnalysisError(this.message);

  @override
  List<Object> get props => [message];
}

class InitializeAudioError extends MentorState {
  final String message;

  const InitializeAudioError(this.message);
}

class ExtractTextFromAudioLoading extends MentorState {}

class ExtractTextFromAudioCompleted extends MentorState {
  final String? text;

  const ExtractTextFromAudioCompleted(this.text);

  @override
  List<Object> get props => [text!];
}

class ExtractTextFromAudioError extends MentorState {
  final String message;

  const ExtractTextFromAudioError(this.message);

  @override
  List<Object> get props => [message];
}

class AudioPlaying extends MentorState {
  final String url;
  final bool isArabic; // تحديد ما إذا كان الصوت عربي أو إنجليزي

  AudioPlaying(this.url, {required this.isArabic});
}

class AudioPlayError extends MentorState {
  final String message;

  const AudioPlayError(this.message);

  @override
  List<Object> get props => [message];
}

class AudioStopped extends MentorState {}

class ArabicAudioPlaying extends MentorState {
  final String url;

  ArabicAudioPlaying(this.url);

  @override
  List<Object> get props => [url];
}

class EnglishAudioPlaying extends MentorState {
  final String url;

  EnglishAudioPlaying(this.url);

  @override
  List<Object> get props => [url];
}

class AudioInitialized extends MentorState {}

class SpeechRecognitionResult extends MentorState {
  final String text;
  SpeechRecognitionResult({required this.text});

  @override
  List<Object> get props => [text];
}

class SpeechRecognitionStarted extends MentorState {}

class SpeechRecognitionStopped extends MentorState {}

class AnalyzingTextState extends MentorState {}
class SpeechRecognitionEnd extends MentorState {}