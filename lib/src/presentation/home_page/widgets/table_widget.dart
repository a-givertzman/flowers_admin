import 'package:flowers_admin/src/infrostructure/schamas/field.dart';
import 'package:flowers_admin/src/infrostructure/schamas/schema.dart';
import 'package:flowers_admin/src/infrostructure/schamas/schema_entry.dart';
import 'package:flowers_admin/src/presentation/home_page/widgets/t_cell.dart';
import 'package:flowers_admin/src/presentation/home_page/widgets/t_cell_list.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';

class TableWidget extends StatefulWidget {
  final Schem _scheme;
  const TableWidget({
    super.key,
    required Schem scheme,
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
  final Schem _scheme;
  // final Map<String, List<SchemeEntry>> _relations = {};
  ///
  ///
  _TableWidgetState({
    required Schem scheme,
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
                if (result.hasError) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Insert error'),
                      content: Text('error: ${result.error}'),
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
        FutureBuilder<Result<List<SchemaEntry>>>(
          future: _scheme.fetch([]),
          builder: (BuildContext context, AsyncSnapshot<Result<List<SchemaEntry>>> snapshot) {
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
        ),
      ],
    );
  }
  ///
  ///
  List<TableRow> _buildRows(Schem<SchemaEntry> scheme, List<SchemaEntry> entries) {
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
        final List<SchemaEntry> relEntries = _scheme.relation(field.relation.id).fold(
          onData: (relSchame) {
            return relSchame.entries;
          }, 
          onError: (_) => [],
        );
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
    }
  }
}


