import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/presentation/home_page/widgets/t_cell.dart';
import 'package:flowers_admin/src/presentation/home_page/widgets/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_failure.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result_new.dart';

class TableWidget extends StatefulWidget {
  final Schema _scheme;
  const TableWidget({
    super.key,
    required Schema scheme,
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
  final Schema _scheme;
  // final Map<String, List<SchemeEntry>> _relations = {};
  ///
  ///
  _TableWidgetState({
    required Schema scheme,
  }) :
    _scheme = scheme;
  ///
  ///
  @override
  void initState() {
    super.initState();
  }
  ///
  ///
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(children: [
          const Expanded(child: SizedBox.shrink()),
          IconButton(
            onPressed: () {
              _scheme.insert().then((result) {
                if (result is Err) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Insert error'),
                      content: Text('error: $result'),
                    ),
                  );
                  return;
                }
                setState(() {});
              });
            }, 
            icon: const Icon(Icons.add),
          ),
        ]),
        FutureBuilder<Result<List<SchemaEntry>, Failure>>(
          future: _scheme.fetch([]),
          builder: (BuildContext context, AsyncSnapshot<Result<List<SchemaEntry>, Failure>> snapshot) {
            final textStile = Theme.of(context).textTheme.bodyMedium;
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(backgroundColor: Colors.blue),
              );
            } else {        
              _log.debug(".build | snapshot: $snapshot");
              final result = snapshot.data;
              if (result != null) {
                return switch(result) {
                  Ok(:final value) => () {
                    final entries = value;
                    if (entries.isNotEmpty) {
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
                  }(),
                  Err(:final error) => () {
                    return Center(child: Text("Error: $error", style: textStile,));
                  }(),
                };
              }
            }
            return Center(child: Text("No orders received", style: textStile,));
          },
        ),
      ],
    );
  }
  ///
  ///
  List<TableRow> _buildRows(Schema<SchemaEntry> scheme, List<SchemaEntry> entries) {
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
        value: field.name,
        style: textStyle,
        editable: false,
      );
    }).toList();
    return cells;
  }
  ///
  ///
  List<Widget> _buildRow(List<Field> fields, SchemaEntry entry, textStyle) {
    final cells = fields
    .where((field) => !field.hidden)
    .map((field) {
      final value = entry.value(field.key);
      if (field.relation.isEmpty) {
        return TCell(
          value: value.value.toString(),
          editable: field.edit,
          style: textStyle,
          onComplete: (value) => _updateEntry(entry, field.key, value),
        );
      } else {
        final List<SchemaEntry> relEntries = switch (_scheme.relation(field.relation.id)) {
          Ok(:final value) => value.entries,
          Err() => [],
        };
        final relation = TCellEntry(entries: relEntries, field: field.relation.field);
        _log.debug("._buildRow | relation '${field.relation.id}': $relation");
        return TCellList(
          id: value.value,
          relation: relation,
          editable: field.edit,
          style: textStyle,
          onComplete: (value) => _updateEntry(entry, field.key, value),
        );
      }
    }).toList();
    return cells;
  }
  ///
  ///
  _updateEntry(SchemaEntry entry, String key, String value) {
    entry.update(key, value);
    if (entry.isChanged) {
      _scheme.update(entry).then((result) {
        if (result is Err) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Update error'),
              content: Text('error: $result'),
            ),
          );          
        }
      });
    }
  }
}


