import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/Action.dart';
import 'package:json_schema_form/json_textform/models/Icon.dart';
import 'package:json_schema_form/json_textform/models/NetworkProvider.dart';
import 'package:provider/provider.dart';

class JSONForignKeyEditField extends StatelessWidget {
  final OnUpdateForignKeyField onUpdateForignKeyField;
  final OnAddForignKeyField onAddForignKeyField;
  final OnFetchingSchema onFetchingSchema;
  final OnFetchForignKeyChoices onFetchingForignKeyChoices;

  /// Model path
  final String path;

  /// On submit button has been clicked
  final Function onSubmit;

  /// Page's title
  final String title;

  /// Page's name
  /// This one is different from the title
  /// and will be used to merge actions and icons.
  final String name;

  /// Model's id. This will be provided if
  /// and only if the mode is editing mode
  final dynamic id;

  /// Whether the mode is editing mode
  final bool isEdit;
  final bool isOutlined;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  const JSONForignKeyEditField({
    @required this.path,
    this.onSubmit,
    this.title,
    this.id,
    this.isOutlined = false,
    this.isEdit = false,
    @required this.name,
    @required this.onFetchingSchema,
    @required this.onFetchingForignKeyChoices,
    @required this.onAddForignKeyField,
    @required this.onUpdateForignKeyField,
    this.actions,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    NetworkProvider provider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        child: FutureBuilder<SchemaValues>(
          future: onFetchingSchema(path, isEdit, id),
          builder: (context, schemaSnapshot) {
            if (!schemaSnapshot.hasData) {
              return CircularProgressIndicator();
            }
            if (schemaSnapshot.hasError) {
              return Center(
                child: Text("${schemaSnapshot.error}"),
              );
            }
            if (schemaSnapshot.data == null) {
              return Container();
            }
            return JSONForm(
              onFetchingSchema: onFetchingSchema,
              onFetchForignKeyChoices: onFetchingForignKeyChoices,
              schemaName: name,
              rounded: isOutlined,
              schema: schemaSnapshot.data.schema,
              values: schemaSnapshot.data.values,
              actions: actions,
              showSubmitButton: true,
              icons: icons,
              onAddForignKeyField: onAddForignKeyField,
              onUpdateForignKeyField: onUpdateForignKeyField,
              onSubmit: (Map<String, dynamic> json) async {
                if (isEdit) {
                  await onUpdateForignKeyField(path, json, id);
                } else {
                  await onAddForignKeyField(path, json);
                }
                Navigator.pop(context);
              },
            );
          },
        ),
      ),
    );
  }
}
