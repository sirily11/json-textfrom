import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/Action.dart';
import 'package:json_schema_form/json_textform/models/Icon.dart';
import 'package:json_schema_form/json_textform/models/NetworkProvider.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

typedef Future OnSubmit(Map<String, dynamic> json);

/// A JSON Schema Form Widget
/// Which will take a schema input
/// and generate a form
class JSONSchemaForm extends StatefulWidget {
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

  /// URL for forignkey
  /// Forignkey field will use this to get editing data
  /// Default is http://0.0.0.0
  final String url;

  /// Round corner of text field
  final bool rounded;

  final Dio networkProvider = Dio();

  JSONSchemaForm({
    @required this.schema,
    this.onSubmit,
    this.icons,
    this.actions,
    this.values,
    this.rounded = false,
    this.schemaName,
    this.url = "http://0.0.0.0",
  });

  @override
  _JSONSchemaFormState createState() => _JSONSchemaFormState();
}

class _JSONSchemaFormState extends State<JSONSchemaForm> {
  final _formKey = GlobalKey<FormState>();
  List<Schema> schemaList = [];
  _JSONSchemaFormState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NetworkProvider>(
          create: (_) => NetworkProvider(
              networkProvider: widget.networkProvider, url: widget.url),
        )
      ],
      child: JSONForm(
        schema: widget.schema,
        schemaName: widget.schemaName,
        onSubmit: widget.onSubmit,
        icons: widget.icons,
        actions: widget.actions,
        values: widget.values,
        rounded: widget.rounded,
      ),
    );
  }
}
