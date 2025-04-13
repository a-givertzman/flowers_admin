import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

///
/// Used to have hover effect on simple widgets
class HoverBuilder extends StatefulWidget {
  const HoverBuilder({
    super.key,
    required this.builder,
  });
  ///
  /// Use to have hover effect on simple widgets
  final Widget Function(BuildContext context, bool isHovered) builder;
  //
  @override
  State<HoverBuilder> createState() => _HoverBuilderState();
}
//
//
class _HoverBuilderState extends State<HoverBuilder> {
  bool _isHovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) => _onHoverChanged(enabled: true),
      onExit: (PointerExitEvent event) => _onHoverChanged(enabled: false),
      child: widget.builder(context, _isHovered),
    );
  }
  ///
  ///
  void _onHoverChanged({required bool enabled}) {
    setState(() {
      _isHovered = enabled;
    });
  }
}