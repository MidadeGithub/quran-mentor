import 'package:quran_mentor/features/mentor/data/models/surah.dart';

class Ayah {
  final String aya;
  final String translation;
  final String mp3;
  final String translationMp3;
  final Sura sura;
  final int ayaId;

  Ayah({
    required this.aya,
    required this.translation,
    required this.mp3,
    required this.translationMp3,
    required this.sura,
    required this.ayaId,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      aya: json['aya'] ?? '',
      translation: json['translation'] ?? '',
      mp3: json['mp3'] ?? '',
      translationMp3: json['translation_mp3'] ?? '',
      sura: Sura.fromJson(json['sura']),
      ayaId: json['aya_id'] ?? 0,
    );
  }
}