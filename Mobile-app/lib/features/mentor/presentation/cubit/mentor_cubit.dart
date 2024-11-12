import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quran_mentor/core/utils/app_strings.dart';
import 'package:quran_mentor/features/mentor/data/models/analyze_result_model/analyze_result_model.dart';
import 'package:quran_mentor/features/mentor/domain/usecases/analyze_text.dart';
import 'package:quran_mentor/features/mentor/domain/usecases/extract_text_from_audio.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

part 'mentor_state.dart';

class MentorCubit extends Cubit<MentorState> {
  final ExtractTextFromAudio extractTextFromAudioUseCase;
  final AnalyzeText analyzeTextUseCase;

  MentorCubit(this.extractTextFromAudioUseCase, this.analyzeTextUseCase)
      : super(MentorInitial());
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecorderInitialized = false;
  bool isRecording = false;
  String recognizedWords = '';
  bool isAnalyzing = false;

  //speech
  final stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;

  Future<void> resetListening() async {
    if (isListening) {
      await stopListening();
    }
    await speech.initialize(); // إعادة التهيئة عند العودة للصفحة
  }

  Future<void> startListening() async {
    await resetListening(); // التأكد من إعادة التهيئة عند بدء الاستماع

    emit(SpeechRecognitionStarted());
    recognizedWords = '';
    isListening = true;

    speech.listen(
      onResult: (result) {
        recognizedWords = result.recognizedWords;
        log('Recognized Words: $recognizedWords');

        // إصدار النتيجة فقط أثناء عدم التحليل
        if (!isAnalyzing) {
          emit(SpeechRecognitionResult(text: recognizedWords));
        }
      },
    );
  }

  Future<void> stopListening() async {
    speech.stop();
    speech.cancel();
    isListening = false;
    emit(SpeechRecognitionStopped());
  }

  Future<void> initializeRecorder() async {
    try {
      await _recorder.openRecorder();
      await Permission.microphone.request();
      isRecorderInitialized = true;
    } catch (e) {
      emit(InitializeAudioError("Failed to initialize recorder: $e"));
    }
  }

  // Future<void> startRecording() async {
  //   emit(MentorInitial());
  //   try {
  //     final directory = await getTemporaryDirectory();
  //     audioFilePath = '${directory.path}/audio.aac'; // تحديد مسار الملف الكامل
  //     await _recorder.startRecorder(toFile: audioFilePath);
  //     isRecording = true;
  //     emit(QuranRecordingStarted());
  //   } catch (e) {
  //     emit(QuranRecordingError("Failed to start recording: $e"));
  //   }
  // }

  String audioFilePath = '';

  // Future<void> stopRecordingAndGetPath() async {
  //   emit(QuranRecordingStarted());
  //   try {
  //     isRecording = false;
  //     final resultPath = await _recorder.stopRecorder();
  //     if (resultPath != null) {
  //       audioFilePath = resultPath; // تأكد من حفظ المسار
  //       log('$audioFilePath', name: 'stopRecordingAndGetPath');
  //       emit(QuranRecordingStopped(audioFilePath));
  //     } else {
  //       emit(QuranRecordingError("Recording file path is null"));
  //     }
  //   } catch (e) {
  //     emit(QuranRecordingError("Failed to stop recording: $e"));
  //   }
  // }

  String? extractedText;

  Future<void> extractTextFromAudio() async {
    emit(ExtractTextFromAudioLoading());
    final response = await extractTextFromAudioUseCase
        .call(ExtractTextFromAudioParams(filePath: audioFilePath));
    response.fold((failure) {
      emit(ExtractTextFromAudioError(failure.message ?? ''));
    }, (value) {
      extractedText = value.data;
      emit(ExtractTextFromAudioCompleted(value.data ?? ''));
    });
  }

  AnalyzeResultModel? analyzeResultModel;

  Future<void> analyzeExtractedText(String text) async {
    isAnalyzing = true;
    emit(QuranAnalysisLoading());
    await Future.delayed(Duration(seconds: 2)); // تأخير مؤقت

    final response =
        await analyzeTextUseCase.call(AnalyzeTextParams(text: text));
    response.fold((failure) {
      emit(QuranAnalysisError(failure.message!));
    }, (value) {
      analyzeResultModel = value.data;
      emit(QuranAnalysisCompleted(analyzeResultModel!));
    });
  }

  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  String? currentArabicAudioUrl;
  String? currentEnglishAudioUrl;

  void playArabicAudio(String url) async {
    try {
      await _player.openPlayer(); // تأكد من فتح الجلسة الصوتية
      currentArabicAudioUrl = url;
      emit(ArabicAudioPlaying(url));
      await _player.startPlayer(fromURI: url); // قم بتحديد مسار الملف الصوتي
    } catch (e) {
      emit(AudioPlayError("Failed to play Arabic audio: $e"));
    }
  }

  void playEnglishAudio(String url) async {
    try {
      await _player.openPlayer(); // تأكد من فتح الجلسة الصوتية
      currentEnglishAudioUrl = url;
      emit(EnglishAudioPlaying(url));
      await _player.startPlayer(fromURI: url); // قم بتحديد مسار الملف الصوتي
    } catch (e) {
      emit(AudioPlayError("Failed to play English audio: $e"));
    }
  }

  Future<void> stopAudio() async {
    try {
      await _player.stopPlayer();
      currentArabicAudioUrl = null;
      currentEnglishAudioUrl = null;
      emit(AudioStopped());
    } catch (e) {
      emit(const AudioPlayError("Failed to stop audio"));
    }
  }
}
