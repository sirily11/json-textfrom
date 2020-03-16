import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/components/JSONDateTimeField.dart';
import 'package:json_schema_form/json_textform/components/JSONForignKeyField.dart';
import 'package:json_schema_form/json_textform/components/JSONSelectField.dart';
import 'package:json_schema_form/json_textform/components/JSONTextFormField.dart';
import 'package:json_schema_form/json_textform/models/Action.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form/json_textform/models/Icon.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/utils.dart';
import 'package:permission_handler/permission_handler.dart';

typedef Future OnSubmit(Map<String, dynamic> json);

/// A JSON Schema Form Widget
/// Which will take a schema input
/// and generate a form
class JSONForm extends StatefulWidget {
  final bool showSubmitButton;

  /// [optional] Schema controller.
  /// Call this to get value back from fields if you want to have
  /// your custom submit button.
  final JSONSchemaController controller;

  /// Schema's name
  /// Use this to identify the actions and icons
  /// if forignkey text field has the same name as the home screen's field.
  /// Default is null
  final String schemaName;

  /// Schema you want to have. This is a JSON object
  /// Using dart's map data structure
  final List<Map<String, dynamic>> schema;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  /// Default values for each field
  final Map<String, dynamic> values;

  /// Will call this function after user
  /// clicked the submit button
  final OnSubmit onSubmit;

  /// Round corner of text field
  final bool rounded;

  JSONForm(
      {@required this.schema,
      this.onSubmit,
      this.icons,
      this.actions,
      this.values,
      this.rounded = false,
      this.schemaName,
      this.controller,
      this.showSubmitButton = false});

  @override
  _JSONSchemaFormState createState() => _JSONSchemaFormState();
}

class _JSONSchemaFormState extends State<JSONForm> {
  final _formKey = GlobalKey<FormState>();
  List<Schema> schemaList = [];
  _JSONSchemaFormState();

  @override
  void initState() {
    super.initState();
    schemaList = Schema.convertFromList(widget.schema);

    /// Merge actions
    if (widget.actions != null) {
      if (Platform.isIOS || Platform.isAndroid) {
        PermissionHandler()
            .requestPermissions([PermissionGroup.camera]).then((m) => null);
      }

      schemaList =
          FieldAction().merge(schemaList, widget.actions, widget.schemaName);
    }

    /// Merge icons
    if (widget.icons != null) {
      schemaList =
          FieldIcon().merge(schemaList, widget.icons, widget.schemaName);
    }

    /// Merge values
    if (widget.values != null) {
      schemaList = Schema.mergeValues(schemaList, widget.values);
    }
    if (widget.controller != null) {
      widget.controller.onSubmit = this.onPressSubmitButton;
    }
  }

  /// Render body widget based on widget type
  Widget _buildBody(Schema schema) {
    switch (schema.widget) {
      case WidgetType.datetime:
        return JSONDateTimeField(
          key: Key(schema.name),
          schema: schema,
          isOutlined: widget.rounded,
          onSaved: (String value) {
            setState(() {
              schema.value = value;
            });
          },
        );

      case (WidgetType.select):
        return JSONSelectField(
          isOutlined: widget.rounded,
          schema: schema,
          onSaved: (Choice value) {
            setState(() {
              schema.value = value.value;
              schema.choice = value;
            });
          },
        );

      case (WidgetType.foreignkey):
        return JSONForignKeyField(
          isOutlined: widget.rounded,
          schema: schema,
          actions: widget.actions,
          icons: widget.icons,
          onSaved: (Choice value) {
            setState(() {
              schema.value = value.value;
              schema.choice = value;
            });
          },
        );

      default:
        return JSONTextFormField(
          key: Key(schema.name),
          schema: schema,
          isOutlined: widget.rounded,
          onSaved: (String value) {
            setState(() {
              schema.value = value;
            });
          },
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView.builder(
                  itemCount: widget.schema.length,
                  itemBuilder: (BuildContext context, int index) {
                    Schema schema = schemaList[index];
                    return schema.readOnly ||
                            schema.widget == WidgetType.unknown
                        ? Container()
                        : _buildBody(schema);
                  },
                ),
              ),
              widget.showSubmitButton
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                            width: 300,
                            height: 40,
                            child: RaisedButton(
                              color: Theme.of(context).buttonColor,
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .primaryTextTheme
                                        .title
                                        .color),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              onPressed: () async {
                                await onPressSubmitButton(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  Future<Map<String, dynamic>> onPressSubmitButton(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // hide keyboard
      FocusScope.of(context).requestFocus(FocusNode());
      Map<String, dynamic> ret = getSubmitJSON(schemaList);
      // call on submit function
      if (widget.onSubmit != null) {
        await widget.onSubmit(ret);
      }
      // clear the content
      _formKey.currentState.reset();
      return ret;
    } else {
      print("Form is not vaild");
    }
  }
}
