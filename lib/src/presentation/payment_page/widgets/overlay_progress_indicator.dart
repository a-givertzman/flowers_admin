import 'package:flutter/material.dart';
///
/// Progress indicator on the transparent widget over the window
class OverlayProgressIndicator extends StatelessWidget {
  ///
  ///
  const OverlayProgressIndicator({super.key});
  //
  //
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withValue(alpha: 0.3),
      child: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}
