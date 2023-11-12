import 'package:flowers_admin/src/infrostructure/schames/field.dart';
import 'package:flowers_admin/src/infrostructure/schames/scheme.dart';
import 'package:flowers_admin/src/infrostructure/schames/scheme_entry.dart';
import 'package:flowers_admin/src/presentation/home_page/widgets/t_cell.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

class TableWidget extends StatefulWidget {
  final Scheme _scheme;
  const TableWidget({
    super.key,
    required Scheme scheme,
  }) :
    _scheme = scheme;
  ///
  ///
  @override
  // ignore: no_logic_in_create_state
  State<TableWidget> createState() => _TableWidgetState(
    scheme: _scheme,
  );
}
///
///
class _TableWidgetState extends State<TableWidget> {
  final _log = Log("$_TableWidgetState");
  final Scheme _scheme;
  final Map<String, List<SchemeEntry>> _relations = {};
  ///
  ///
  _TableWidgetState({
    required Scheme scheme,
  }) :
    _scheme = scheme;
  ///
  ///
  @override
  void initState() {
    for (final field in _scheme.fields) {
      if (field.relation.isNotEmpty) {
        _scheme.relation(field.relation).fold(
          onData: (scheme) {
            scheme.refresh().then((result) {
              result.fold(
                onData: (entries) {
                  _relations[field.relation] = entries;
                },
                onError: (err) {
                  _log.warning(".initState | relation '${field.relation}' refresh error: $err");
                },
              );
            });
          }, 
          onError: (err) {
            _log.warning(".initState | relation '${field.relation}' - not found\n\terror: $err");
          },
        );
      }
    }
    super.initState();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Result<List<SchemeEntry>>>(
      future: _scheme.fetch([]),
      builder: (BuildContext context, AsyncSnapshot<Result<List<SchemeEntry>>> snapshot) {
        final textStile = Theme.of(context).textTheme.bodyMedium;
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: CircularProgressIndicator(backgroundColor: Colors.blue),
          );
        } else {        
          _log.debug(".build | snapshot: $snapshot");
          final result = snapshot.data;
          if (result != null) {
            if (result.hasData) {
              final entries = result.data;
              if (entries.isNotEmpty) {
                // final count = entries.length;
                final rows = entries;
                return Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(),
                  columnWidths: { for (var i in [for (var i = 0; i <= 14; i++) i]) i : const IntrinsicColumnWidth() },
                  // {
                  //   0: IntrinsicColumnWidth(),
                  //   1: FlexColumnWidth(),
                  // },
                  children: _buildRows(_scheme, rows),
                );
              } else {
                return Center(child: Text("No orders received", style: textStile,));
              }
            } else {
              return Center(child: Text("Error: ${result.error}", style: textStile,));
            }
          }
        }
        return Center(child: Text("No orders received", style: textStile,));
      },
    );
  }
  ///
  ///
  List<TableRow> _buildRows(Scheme<SchemeEntry> scheme, List<SchemeEntry> entries) {
    final textStile = Theme.of(context).textTheme.bodyMedium;
    final rows = [TableRow(children: _buildHead(scheme.fields, textStile))];
    rows.addAll(
      entries.map((entry) {
        return TableRow(
          children: _buildRow(scheme.fields, entry, textStile),
        );
      }),
    );
    return rows;
  }
  ///
  ///
  List<Widget> _buildHead(List<Field> fields, textStyle) {
    final cells = fields
    .where((field) => !field.hidden)
    .map((field) {
      return TCell(
        // key: Key(entry.key),
        value: field.name,
        style: textStyle,
        editable: false,
      );
    }).toList();
    return cells;
  }
  ///
  ///
  List<Widget> _buildRow(List<Field> fields, SchemeEntry entry, textStyle) {
    final cells = fields
    .where((field) => !field.hidden)
    .map((field) {
      final value = entry.value(field.key);
      return TCell(
        // key: Key(entry.key),
        value: value.value.toString(),
        editable: field.edit,
        style: textStyle,
        onComplete: (value) {
          entry.update(field.key, value);
          _scheme.update(entry).then((result) {
            if (result.hasError) {
              showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                      title: const Text('Update error'),
                      content: Text('error: ${result.error}'),
                  ),
              );          
            }
          });
        },
      );
    }).toList();
    return cells;
  }
}


