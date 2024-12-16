import 'package:flowers_admin/src/core/result/result.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flutter/material.dart';

///
/// Shows a confirm dialogue with Yes / No buttons
Future<Result<void, void>> showConfirmDialog(BuildContext context, Widget title, Widget content) {
  return showDialog<Result>(
    context: context,
    builder: (_) => AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          child: Text('Cancel'.inRu),
          onPressed:  () {
            Navigator.pop(context, const Err(null));
          },
        ),
        TextButton(
          child: Text('Yes'.inRu),
          onPressed:  () {
            Navigator.pop(context, const Ok(null));
          },
        ),
      ],              
    ),
  )
  .then((value) => value ?? const Err(null));
}
