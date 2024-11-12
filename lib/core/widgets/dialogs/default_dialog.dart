import 'package:flutter/material.dart';
import 'package:quran_mentor/core/utils/media_query_values.dart';

Future showDefaultDialog(BuildContext context, Widget body,
    {double height = 50}) {
  return showDialog(
      // barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Material(
          child: Container(
              // height: height,
              margin: EdgeInsets.symmetric(
                  vertical: context.height * 0.3,
                  horizontal: context.width * 0.5),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              width: context.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: body,
              )),
        );
      });
}
