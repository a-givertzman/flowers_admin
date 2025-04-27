import 'package:ext_rw/ext_rw.dart';
import 'package:flowers_admin/src/core/translate/translate.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user.dart';
import 'package:flowers_admin/src/infrostructure/app_user/app_user_role.dart';
import 'package:flowers_admin/src/infrostructure/purchase/entry_purchase.dart';
import 'package:flowers_admin/src/infrostructure/purchase/purchase_status.dart';
import 'package:flowers_admin/src/presentation/core/edit_widgets/text_edit_widget.dart';
import 'package:flowers_admin/src/presentation/core/form_widget/edit_list_widget.dart';
import 'package:flowers_admin/src/presentation/core/image_widget/load_image_widget/load_image_widget.dart';
import 'package:flowers_admin/src/presentation/core/table_widget/edit_list_entry.dart';
import 'package:flutter/material.dart';
import 'package:hmi_core/hmi_core_log.dart';
import 'package:hmi_core/hmi_core_result.dart';
///
///
class EditPurchaseForm extends StatefulWidget {
  final AppUser user;
  final List<Field> fields;
  final EntryPurchase? entry;
  final Map<String, List<SchemaEntryAbstract>> relations;
  ///
  ///
  const EditPurchaseForm({
    super.key,
    required this.user,
    required this.fields,
    this.entry,
    this.relations = const {},
  });
  //
  //
  @override
  // ignore: no_logic_in_create_state
  State<EditPurchaseForm> createState() => _EditPurchaseFormState();
}
//
//
class _EditPurchaseFormState extends State<EditPurchaseForm> {
  late final Log _log;
  late EntryPurchase _entry;
  //
  //
  @override
  void initState() {
    _log = Log("$runtimeType");
    _entry = widget.entry ?? EntryPurchase.empty();
    super.initState();
  }
  ///
  ///
  Field _field(List<Field> fields, String key) {
    return fields.firstWhere((element) => element.key == key, orElse: () {
      return Field<EntryPurchase>(key: key);
    },);
  }
  //
  //
  @override
  Widget build(BuildContext context) {
    final statusField = _field(widget.fields, 'status');
    _log.debug('.build | statusField: $statusField');
    _log.trace('.build | relations: ${widget.relations}');
    final statusRelation = PurchaseStatus.values.asMap().map((i, role) {
      return MapEntry(role.str, EntryPurchase(map: {'id': FieldValue(role.str), 'status': FieldValue(role.str)}));
    },);
    _log.debug('.build | statusRelation: $statusRelation');
    return Padding(
      padding: const EdgeInsets.all(64.0),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('${InRu('Edit customer')} ${_entry.value('name')}', style: Theme.of(context).textTheme.titleLarge,),
              Row(
                // crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        LoadImageWidget(
                          labelText: _field(widget.fields, 'picture').title.inRu,
                          src: '${_entry.value('picture').value}',
                          onComplete: (value) {
                            _entry.update('picture', value);
                            setState(() {return;});
                          },
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        TextEditWidget(
                          labelText: _field(widget.fields, 'name').title.inRu,
                          value: '${_entry.value('name').value}',
                          onComplete: (value) {
                            _entry.update('name', value);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: _field(widget.fields, 'details').title.inRu,
                          value: '${_entry.value('details').value}',
                          onComplete: (value) {
                            _entry.update('details', value);
                            setState(() {return;});
                          },
                        ),
                        EditListWidget(
                          id: '${_entry.value('status').value}',
                          relation: EditListEntry(field: 'status', entries: statusRelation.values.toList()),
                          editable: [AppUserRole.admin, AppUserRole.operator].contains(widget.user.role),
                          // style: textStyle,
                          labelText: _field(widget.fields, 'Status').title.inRu,
                          onComplete: (id) {
                            final status = statusRelation[id]?.value('status').value;
                            _log.debug('build.onComplete | status: $status');
                            if (status != null) {
                              _entry.update('status', status);
                              setState(() {return;});
                            }
                          },
                        ),
                        InputDatePickerFormField(
                          fieldLabelText: _field(widget.fields, 'date_of_start').title.inRu,
                          initialDate: DateTime.tryParse('${_entry.value('date_of_start').value}'),
                          firstDate: DateTime(DateTime.now().year - 10),  //'${_entry.value('date_of_start').value}',
                          lastDate: DateTime(DateTime.now().year + 20),
                          onDateSubmitted: (value) {
                            final dateTime = value.toIso8601String();
                            _entry.update('date_of_start', dateTime);
                            setState(() {return;});
                          },
                        ),
                        InputDatePickerFormField(
                          fieldLabelText: _field(widget.fields, 'date_of_end').title.inRu,
                          initialDate: DateTime.tryParse('${_entry.value('date_of_end').value}'),
                          firstDate: DateTime(DateTime.now().year - 10),  //'${_entry.value('date_of_start').value}',
                          lastDate: DateTime(DateTime.now().year + 20),
                          onDateSubmitted: (value) {
                            final dateTime = value.toIso8601String();
                            _entry.update('date_of_end', dateTime);
                            setState(() {return;});
                          },
                        ),
                        TextEditWidget(
                          labelText: _field(widget.fields, 'date_of_start').title.inRu,
                          value: '${_entry.value('date_of_start').value}',
                        ),
                        TextEditWidget(
                          labelText: _field(widget.fields, 'date_of_end').title.inRu,
                          value: '${_entry.value('date_of_end').value}',
                        ),
                        TextEditWidget(
                          labelText: _field(widget.fields, 'description').title.inRu,
                          value: '${_entry.value('description').value}',
                          onComplete: (value) {
                            _entry.update('description', value);
                            setState(() {return;});
                          },
                        ),                      
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: OverflowBar(
            children: [
              TextButton(
                onPressed:  () {
                  Navigator.pop(context, const Err<EntryPurchase, void>(null));
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: _entry.isChanged 
                  ? () {
                    _log.debug('.TextButton.Yes | isChanged: ${_entry.isChanged}');
                    _log.debug('.TextButton.Yes | enrty: $_entry');
                    Navigator.pop(context, Ok<EntryPurchase, void>(_entry));
                  } 
                  : null,
                child: const Text("Yes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
