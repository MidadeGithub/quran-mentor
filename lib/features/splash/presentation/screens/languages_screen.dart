// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:quran_mentor/core/utils/assets_manager.dart';

// class LanguagesScreen extends StatefulWidget {
//   const LanguagesScreen({super.key});

//   @override
//   State<LanguagesScreen> createState() => _LanguagesScreenState();
// }

// class _LanguagesScreenState extends State<LanguagesScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GestureDetector(
//         onTap: () {
//           FocusManager.instance.primaryFocus?.unfocus();
//         },
//         child: Stack(
//           children: [
//             SizedBox(
//               child: Image.asset(
//                 AppAssets.langBG,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Align(
//                 alignment: Alignment.bottomCenter, child: _buildBodyContent()),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBodyContent() {
//     return BlocBuilder<LocaleCubit, LocaleState>(
//       builder: (context, state) {
//         return Container(
//           height: context.height * 0.5,
//           padding: EdgeInsets.all(24),
//           decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(24), topLeft: Radius.circular(24)),
//             color: Colors.white,
//           ),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.language,
//                       color: AppColors.primaryColor,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       AppLocalizations.of(context)!.translate('choose_lang')!,
//                       style: Theme.of(context).textTheme.headlineLarge,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: context.height * 0.05,
//                 ),
//                 DefaultTextFormField(
//                   // hintTxt: 'ابحث عن لغة',
//                   hintTxt: AppLocalizations.of(context)!
//                       .translate('search_for_lang')!,
//                   filledColor: HexColor('F5F5F5'),
//                   borderColor: Colors.transparent,
//                   marginIsEnabled: false,
//                   suffixIcon: Icon(
//                     Icons.search,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 SizedBox(height: context.height * 0.03),
//                 LanguageWidgetItem(
//                   isSelected:
//                       context.read<LocaleCubit>().currentLangCode == 'ar',
//                   langTitle: AppLocalizations.of(context)!.translate('arabic')!,
//                   iconPath: AppAssets.arabicIcon,
//                   onTap: () => context.read<LocaleCubit>().toArabic(),
//                 ),
//                 LanguageWidgetItem(
//                   isSelected:
//                       context.read<LocaleCubit>().currentLangCode == 'en',
//                   langTitle:
//                       AppLocalizations.of(context)!.translate('english')!,
//                   iconPath: AppAssets.englishIcon,
//                   onTap: () => context.read<LocaleCubit>().toEnglish(),
//                 ),
//                 SizedBox(height: context.height * 0.03),
//                 DefaultButton(
//                     withIcon: true,
//                     margin: 0,
//                     btnLbl: AppLocalizations.of(context)!.translate('save')!,
//                     icon: Icon(Icons.save),
//                     onPressed: () {
//                       Constants.showToast(
//                           message: AppLocalizations.of(context)!
//                               .translate('saved')!);
//                       Navigator.pushNamed(context, Routes.onboardingScreen);
//                     })
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
