
import 'package:flutter/material.dart';

///
///
class TRow extends StatelessWidget {
  final List<Widget> _cells;
  final void Function()? _onTap;
  ///
  ///
  const TRow({
    super.key,
    bool selected = false,
    required List<Widget> children,
    void Function()? onTap,
  }) :
    _cells = children,
    _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _buildCells(context, _cells),
    );
  }
  ///
  ///
  List<Widget> _buildCells(BuildContext context, List<Widget> cells) {
    return cells.map((cell) {
      return InkWell(
        onTap: _onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 2.5),
          decoration: const BoxDecoration(
            border: Border.symmetric(
              vertical: BorderSide(),
            ),
          ),
          child: cell,
        ),
      );
    }).toList();
  }
}

