import 'package:quran_mentor/features/mentor/data/models/ayah.dart';

class AnalyzeResultModel {
  final String query;
  final Map<String, int> tags;
  final List<Ayah> ayat;

  AnalyzeResultModel({
    required this.query,
    required this.tags,
    required this.ayat,
  });

  factory AnalyzeResultModel.fromJson(Map<String, dynamic> json) {
    return AnalyzeResultModel(
      query: json['q'] ?? '',
      tags: Map<String, int>.from(json['tags'] ?? {}),
      ayat: (json['ayat'] as List<dynamic>)
          .map((ayahJson) => Ayah.fromJson(ayahJson))
          .toList(),
    );
  }
}
