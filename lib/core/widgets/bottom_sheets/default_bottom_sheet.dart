import 'package:flutter/material.dart';
import 'package:quran_mentor/core/utils/media_query_values.dart';

import '../../utils/app_colors.dart';

Future<dynamic> showDefaultButtomSheet(
  BuildContext context, {
  required String title,
  required Widget body,
  bool bodyScrollable = false,
  bool isDismissible = false,
  bool withCloseIcon = false,
}) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: isDismissible,
      context: context,
      builder: (context) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: SizedBox(
              height: bodyScrollable ? context.height * 0.9 : null,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Center(
                        child: Container(
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                          color: AppColors.greyColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(30)),
                    )),
                    const SizedBox(height: 10),
                    !withCloseIcon
                        ? Center(
                            child: Text(
                              title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    color: const Color(0xFF6B482F),
                                    fontSize: 16,
                                    fontFamily: 'Qatar2022 Arabic',
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          )
                        : Stack(
                            alignment: Alignment.centerLeft,
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Text(
                                  title,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(
                                        color: const Color(0xFF0D0D0D),
                                        fontSize: 16,
                                        fontFamily: 'Graphik Arabic',
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  )),
                              //
                            ],
                          ),
                    const SizedBox(height: 20),
                    body,
                  ],
                ),
              ),
            ),
          ));
}
