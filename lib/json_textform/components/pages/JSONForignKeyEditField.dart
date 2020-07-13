import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/models/components/Action.dart';
import 'package:json_schema_form/json_textform/models/components/Icon.dart';

enum RequestAction { delete, update, add }

class ReturnChoice {
  Choice choice;
  RequestAction action;

  ReturnChoice({this.choice, this.action});
}

/// Edit foreignkey field
class JSONforeignKeyEditField extends StatefulWidget {
  final OnSearch onSearch;
  final OnDeleteforeignKeyField onDeleteforeignKeyField;
  final OnFileUpload onFileUpload;
  final OnUpdateforeignKeyField onUpdateforeignKeyField;
  final OnAddforeignKeyField onAddforeignKeyField;
  final OnFetchingSchema onFetchingSchema;
  final OnFetchforeignKeyChoices onFetchingforeignKeyChoices;
  final bool useDialog;

  final bool filled;

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

  const JSONforeignKeyEditField({
    @required this.path,
    this.title,
    this.id,
    this.isOutlined = false,
    this.isEdit = false,
    @required this.onSearch,
    @required this.filled,
    @required this.useDialog,
    @required this.name,
    @required this.onFetchingSchema,
    @required this.onFetchingforeignKeyChoices,
    @required this.onAddforeignKeyField,
    @required this.onUpdateforeignKeyField,
    @required this.onFileUpload,
    @required this.onDeleteforeignKeyField,
    this.actions,
    this.icons,
  });

  @override
  _JSONforeignKeyEditFieldState createState() =>
      _JSONforeignKeyEditFieldState();
}

class _JSONforeignKeyEditFieldState extends State<JSONforeignKeyEditField> {
  final JSONSchemaController controller = JSONSchemaController();

  Widget buildBody() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: FutureBuilder<SchemaValues>(
        future: widget.onFetchingSchema(widget.path, widget.isEdit, widget.id),
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
            onSearch: widget.onSearch,
            filled: widget.filled,
            controller: controller,
            useDialog: widget.useDialog,
            onFetchingSchema: widget.onFetchingSchema,
            onFetchforeignKeyChoices: widget.onFetchingforeignKeyChoices,
            schemaName: widget.name,
            rounded: widget.isOutlined,
            schema: schemaSnapshot.data.schema,
            values: schemaSnapshot.data.values,
            actions: widget.actions,
            showSubmitButton: !widget.useDialog,
            icons: widget.icons,
            onAddforeignKeyField: widget.onAddforeignKeyField,
            onUpdateforeignKeyField: widget.onUpdateforeignKeyField,
            onDeleteforeignKeyField: widget.onDeleteforeignKeyField,
            onFileUpload: widget.onFileUpload,
            onSubmit: (Map<String, dynamic> json) async {
              await onSubmit(json, context);
            },
          );
        },
      ),
    );
  }

  Future<void> onSubmit(Map<String, dynamic> json, BuildContext context) async {
    if (json == null) {
      return;
    }

    if (widget.isEdit) {
      if (widget.onUpdateforeignKeyField != null) {
        Choice choice =
            await widget.onUpdateforeignKeyField(widget.path, json, widget.id);
        Navigator.pop<ReturnChoice>(
          context,
          ReturnChoice(
            action: RequestAction.update,
            choice: choice,
          ),
        );
      }
    } else {
      if (widget.onAddforeignKeyField != null) {
        Choice choice = await widget.onAddforeignKeyField(widget.path, json);
        Navigator.pop(
          context,
          ReturnChoice(action: RequestAction.add, choice: choice),
        );
      }
    }
  }

  IconButton buildDeleteButton(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (widget.onDeleteforeignKeyField != null) {
          Choice choice =
              await widget.onDeleteforeignKeyField(widget.path, widget.id);
          Navigator.pop(
            context,
            ReturnChoice(action: RequestAction.delete, choice: choice),
          );
        }
      },
      icon: Icon(Icons.delete),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useDialog) {
      return AlertDialog(
        title: Row(
          children: [
            Text("${widget.title}"),
            if (widget.isEdit) buildDeleteButton(context)
          ],
        ),
        content: Container(
          width: 600,
          child: buildBody(),
        ),
        actions: [
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          FlatButton(
            onPressed: () async {
              await controller.onSubmit(context);
            },
            child: Text("Submit"),
          )
        ],
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
        leading: BackButton(
          key: Key("Back"),
        ),
        actions: <Widget>[if (widget.isEdit) buildDeleteButton(context)],
      ),
      body: buildBody(),
    );
  }
}
