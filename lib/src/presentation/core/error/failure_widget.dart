import 'package:flutter/material.dart';
///
/// Error widget with reload buttor
class FailureWidget extends StatelessWidget {
  final String? error;
  final TextStyle? textStile;
  final void Function()? onReload;
  ///
  /// Error widget with reload button
  const FailureWidget({
    super.key,
    this.error,
    this.textStile,
    this.onReload,
  });
  //
  //
  @override
  Widget build(BuildContext context) {
    final style = textStile ?? Theme.of(context).textTheme.bodyMedium;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(child: Text("Error: $error", style: style)),
        Divider(indent: 8.0, color: Colors.transparent,),
        TextButton(
          onPressed: onReload,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Reload'),
              Divider(indent: 8.0, color: Colors.transparent),
              Icon(Icons.refresh),
            ],
          )
        ),
      ],
    );
  }
}