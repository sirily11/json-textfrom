import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/models/components/Action.dart';
import 'package:json_schema_form/json_textform/models/components/Icon.dart';

enum RequestAction { delete, update, add }

class ReturnChoice {
  Choice choice;
  RequestAction action;

  ReturnChoice({this.choice, this.action});
}

/// Edit forignkey field
class JSONForignKeyEditField extends StatelessWidget {
  final OnDeleteForignKeyField onDeleteForignKeyField;
  final OnFileUpload onFileUpload;
  final OnUpdateForignKeyField onUpdateForignKeyField;
  final OnAddForignKeyField onAddForignKeyField;
  final OnFetchingSchema onFetchingSchema;
  final OnFetchForignKeyChoices onFetchingForignKeyChoices;

  /// Model path
  final String path;

  /// Page's title
  final String title;

  /// Page's name
  /// This one is different from the title
  /// and will be used to merge actions and icons.
  final String name;

  /// Model's id. This will be provided if
  /// and only if the mode is in editing mode
  final dynamic id;

  /// Whether the mode is in editing mode
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
    this.title,
    this.id,
    this.isOutlined = false,
    this.isEdit = false,
    @required this.name,
    @required this.onFetchingSchema,
    @required this.onFetchingForignKeyChoices,
    @required this.onAddForignKeyField,
    @required this.onUpdateForignKeyField,
    @required this.onFileUpload,
    @required this.onDeleteForignKeyField,
    this.actions,
    this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$title"),
        leading: BackButton(
          key: Key("Back"),
        ),
        actions: <Widget>[
          if (isEdit)
            IconButton(
              onPressed: () async {
                if (onDeleteForignKeyField != null) {
                  Choice choice = await onDeleteForignKeyField(path, id);
                  Navigator.pop(
                    context,
                    ReturnChoice(action: RequestAction.delete, choice: choice),
                  );
                }
              },
              icon: Icon(Icons.delete),
            )
        ],
      ),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 100),
        child: FutureBuilder<SchemaValues>(
          future: onFetchingSchema(path, isEdit, id),
          builder: (context, schemaSnapshot) {
            if (!schemaSnapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
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
              onDeleteForignKeyField: onDeleteForignKeyField,
              onFileUpload: onFileUpload,
              onSubmit: (Map<String, dynamic> json) async {
                if (isEdit) {
                  if (onUpdateForignKeyField != null) {
                    Choice choice =
                        await onUpdateForignKeyField(path, json, id);
                    Navigator.pop<ReturnChoice>(
                      context,
                      ReturnChoice(
                        action: RequestAction.update,
                        choice: choice,
                      ),
                    );
                  }
                } else {
                  if (onAddForignKeyField != null) {
                    Choice choice = await onAddForignKeyField(path, json);
                    Navigator.pop(
                      context,
                      ReturnChoice(action: RequestAction.add, choice: choice),
                    );
                  }
                }
              },
            );
          },
        ),
      ),
    );
  }
}
