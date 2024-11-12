import 'dart:io';

import 'package:dio/dio.dart';
import 'package:quran_mentor/core/api/api_consumer.dart';
import 'package:quran_mentor/core/api/base_response.dart';
import 'package:quran_mentor/core/api/end_points.dart';
import 'package:quran_mentor/core/utils/constants.dart';
import 'package:quran_mentor/features/mentor/data/models/analyze_result_model/analyze_result_model.dart';

abstract class MentorRemoteDataSource {
  Future<BaseResponse> extractTextFromAudio(String filePath);
  Future<BaseResponse> analyzeExtractedText(String text);
}

class MentorRemoteDataSourceImpl implements MentorRemoteDataSource {
  final ApiConsumer apiConsumer;
  MentorRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<BaseResponse> analyzeExtractedText(String text) async {
    final response = await apiConsumer.get(
      EndPoints.analyzeExtractedText,
      queryParameters: {
        'q': text,
      },
    );
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    var jsonResponse = Constants.decodeJson(response);
    baseResponse.data = AnalyzeResultModel.fromJson(jsonResponse);
    baseResponse.message = jsonResponse['message'];

    return baseResponse;
  }

  @override
  Future<BaseResponse> extractTextFromAudio(String filePath) async {
    final response = await apiConsumer
        .post(EndPoints.extractTextFromAudio, formDataIsEnabled: true, body: {
      'fle': MultipartFile.fromFileSync(filePath),
      'onlyText': '1',
    });
    BaseResponse baseResponse = BaseResponse(statusCode: response.statusCode);
    // var jsonResponse = Constants.decodeJson(response);
    // baseResponse.data = AnalyzeResultModel.fromJson(jsonResponse);
    if (response.statusCode == 200) {
      baseResponse.message = 'Success';
      baseResponse.data = response.data;
    }

    return baseResponse;
  }
}
