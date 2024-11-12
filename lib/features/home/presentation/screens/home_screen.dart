import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quran_mentor/config/routes/app_route.dart';
import 'package:quran_mentor/core/utils/assets_manager.dart';
import 'package:quran_mentor/core/utils/constants.dart';
import 'package:quran_mentor/core/utils/media_query_values.dart';
import 'package:quran_mentor/core/widgets/default_text_form_field/default_text_form_field.dart';
import 'package:quran_mentor/core/widgets/dialogs/default_dialog.dart';
import 'package:quran_mentor/core/widgets/loading_indicator.dart';
import 'package:quran_mentor/features/mentor/presentation/cubit/mentor_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _textFocused = FocusNode();

  _initRecording() async {
    await context.read<MentorCubit>().initializeRecorder();
  }

  @override
  void initState() {
    super.initState();
    _initRecording();
  }

  @override
  void dispose() {
    textController.dispose();
    _textFocused.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        // bottomNavigationBar: speakerWidget(),
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Center(
            child: BlocBuilder<MentorCubit, MentorState>(
                builder: (context, state) {
              String displayedText = '';
              if (state is SpeechRecognitionResult) {
                displayedText = state.text;
              }
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: context.height,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Quran Mentor',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        'Welcome to Quran Mentor app, The application is for analyzing spoken words with references from the Quran, both audible and visual.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      if (context.read<MentorCubit>().isListening)
                        Image.asset(
                          AppAssets.loadingAnimatedGif,
                          color: Colors.black,
                        ),
                      if (state is SpeechRecognitionResult) Text(state.text),
                      if (state is QuranAnalysisLoading)
                        const Expanded(child: LoadingIndicator()),
                      const Spacer(),
                      speakerWidget()
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  speakerWidget() {
    return BlocConsumer<MentorCubit, MentorState>(
      listener: (context, state) {
        if (state is QuranAnalysisCompleted) {
          Navigator.pushNamed(context, Routes.analyzeResultScreen,
              arguments: state.result);
        }
        if (state is SpeechRecognitionStopped) {
          context.read<MentorCubit>().analyzeExtractedText(
              context.read<MentorCubit>().recognizedWords);
          context.read<MentorCubit>().recognizedWords = '';
        }
        if (state is QuranAnalysisError) {
          Constants.showError(context, state.message);
        }

        if (state is InitializeAudioError) {
          Constants.showError(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is ExtractTextFromAudioLoading) {
          return const LoadingIndicator();
        }
        return SizedBox(
          width: context.width,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: formKey,
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (!context.read<MentorCubit>().isListening) {
                          context.read<MentorCubit>().startListening();
                        } else {
                          context.read<MentorCubit>().stopListening();
                        }
                      },
                      child: Icon(
                        !context.read<MentorCubit>().isListening
                            ? Icons.mic
                            : Icons.mic_off,
                        size: 30,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: DefaultTextFormField(
                      focusNode: _textFocused,
                      controller: textController,
                      onTap: () {},
                      hintTxt: 'Enter your text here',
                      enabled: !context.read<MentorCubit>().isListening,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (textController.text.isNotEmpty) {
                          context
                              .read<MentorCubit>()
                              .analyzeExtractedText(textController.text);
                        } else {
                          Constants.showError(
                              context, 'Please enter text first');
                        }
                      },
                      child: const Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
