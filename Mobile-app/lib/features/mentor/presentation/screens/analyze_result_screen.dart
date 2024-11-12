import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:quran_mentor/config/routes/app_route.dart';
import 'package:quran_mentor/core/widgets/default_back_button.dart';
import 'package:quran_mentor/core/widgets/default_button.dart';
import 'package:quran_mentor/features/mentor/data/models/analyze_result_model/analyze_result_model.dart';
import 'package:quran_mentor/features/mentor/presentation/cubit/mentor_cubit.dart';

class AnalyzeResultScreen extends StatefulWidget {
  final AnalyzeResultModel analyzeResult;

  AnalyzeResultScreen({required this.analyzeResult});

  @override
  State<AnalyzeResultScreen> createState() => _AnalyzeResultScreenState();
}

class _AnalyzeResultScreenState extends State<AnalyzeResultScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<MentorCubit>(context).recognizedWords = '';
    BlocProvider.of<MentorCubit>(context).speech.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Analysis Results'),
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back),
      //     onPressed: () {
      //       Navigator.pushNamedAndRemoveUntil(
      //           context,
      //           Routes.homeScreen,
      //           (route) =>
      //               //remove all previous routes
      //               false);
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: DefaultButton(
            buttonColor: const Color.fromARGB(255, 0, 0, 0),
            btnLbl: 'Done',
            onPressed: () {
              Phoenix.rebirth(context);
            }),
      ),
      body: WillPopScope(
        onWillPop: () async {
          return true;
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Text: ${widget.analyzeResult.query}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Tags:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...widget.analyzeResult.tags.entries.map((entry) {
                    return Text(
                      '${entry.key}: ${entry.value}%',
                      style: const TextStyle(fontSize: 16),
                    );
                  }),
                  const SizedBox(height: 20),
                  const Text(
                    'Ayat:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...widget.analyzeResult.ayat.map((ayat) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Arabic Verse: ${ayat.aya}',
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            children: [
                              BlocBuilder<MentorCubit, MentorState>(
                                builder: (context, state) {
                                  bool isPlayingArabicAudio =
                                      state is ArabicAudioPlaying &&
                                          state.url == ayat.mp3;
                                  return IconButton(
                                    icon: Icon(isPlayingArabicAudio
                                        ? Icons.stop
                                        : Icons.play_arrow),
                                    onPressed: () {
                                      if (isPlayingArabicAudio) {
                                        context.read<MentorCubit>().stopAudio();
                                      } else {
                                        context
                                            .read<MentorCubit>()
                                            .playArabicAudio(ayat.mp3);
                                      }
                                    },
                                  );
                                },
                              ),
                              const Text("Play Arabic Audio"),
                            ],
                          ),
                          Text(
                            'Translation: ${ayat.translation}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.grey[700]),
                          ),
                          Row(
                            children: [
                              BlocBuilder<MentorCubit, MentorState>(
                                builder: (context, state) {
                                  bool isPlayingEnglishAudio =
                                      state is EnglishAudioPlaying &&
                                          state.url == ayat.translationMp3;
                                  return IconButton(
                                    icon: Icon(isPlayingEnglishAudio
                                        ? Icons.stop
                                        : Icons.play_arrow),
                                    onPressed: () {
                                      if (isPlayingEnglishAudio) {
                                        context.read<MentorCubit>().stopAudio();
                                      } else {
                                        context
                                            .read<MentorCubit>()
                                            .playEnglishAudio(
                                                ayat.translationMp3);
                                      }
                                    },
                                  );
                                },
                              ),
                              const Text("Play English Audio"),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
