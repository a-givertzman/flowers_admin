
import 'package:flowers_admin/src/presentation/home_page/widgets/t_cell.dart';
import 'package:flutter/material.dart';

///
///
class TRow extends StatelessWidget {
  final List<TCell> _cells;
  const TRow({
    super.key,
    required List<TCell> cells,
  }) :
    _cells = cells;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _buildCells(context, _cells),
    );
  }
  ///
  ///
  List<Widget> _buildCells(BuildContext context, List<TCell> cells) {
    return cells.map((cell) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 1.5, horizontal: 2.5),
        decoration: const BoxDecoration(
          border: Border.symmetric(
            vertical: BorderSide(),
          ),
        ),
        child: cell,
      );
    }).toList();
  }
}

