import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_result.dart';

///
/// Shows a info modal dialogue with single action
Future<Result<void, void>> showInfoDialog({required BuildContext context, Widget? title, Widget? content}) {
  return showDialog<Result>(
    context: context,
    builder: (_) => AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          child: Text('Ok'.inRu),
          onPressed:  () {
            Navigator.pop(context, const Err(null));
          },
        ),
      ],              
    ),
  )
  .then((value) => value ?? const Err(null));
}
