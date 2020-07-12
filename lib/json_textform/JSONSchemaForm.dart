import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/components/Action.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form/json_textform/models/NetworkProvider.dart';
import 'package:provider/provider.dart';
import 'models/components/Icon.dart';

/// A JSON Schema Form Widget
/// Which will take a schema input
/// and generate a form
class JSONSchemaForm extends StatelessWidget {
  /// Use dialog instead of normal materialPageRoute
  final bool useDialog;

  /// Text form style is filled
  final bool filled;

  /// Whenever user click the button inside filefield,
  /// this function callback will be called
  final OnFileUpload onFileUpload;

  /// schema controller to control the form
  final JSONSchemaController controller;

  /// Fetching choices for foreign key selections
  final OnFetchforeignKeyChoices onFetchingforeignKeyChoices;

  /// Update foreign key's value and return Choice represents the update value.
  /// return null if nothing change
  ///
  /// * [path] A string represents current model's relatedModel value
  /// * [values] A map of values where key represents field's name
  /// and value represents field's value
  /// * [id] a string/number represents the current object
  final OnUpdateforeignKeyField onUpdateforeignKeyField;

  /// Whenever user want to add foreignkey, this function will be called.
  /// Should return a choice object after creating foreignkey.
  ///
  /// * [path] A string represents current model's relatedModel value
  /// * [values] A map of values where key represents field's name
  /// and value represents field's value
  final OnAddforeignKeyField onAddforeignKeyField;

  /// Fetching foreign key's schema. Will be used to generate form for
  /// foreignkey.
  ///
  /// * [path] A string represents current model's relatedModel value
  /// * [isEdit] A bool represents current mode. If true, then
  /// should return a schema and values, otherwise, should return schema only
  /// * [id] A value represents current object. Will be null if [isEdit] is false.
  final OnFetchingSchema onFetchingSchema;

  /// Whenever user want to delete a foreignkey object, this function
  /// will be called
  ///
  /// * [path] A string represents current model's relatedModel value
  /// * [id] a string/number represents the current object
  final OnDeleteforeignKeyField onDeleteforeignKeyField;

  /// Schema's name
  /// Use this to identify the actions and icons
  /// if foreignkey text field has the same name as the home screen's field.
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
  ///
  /// * [json] A map. keys represent fields' name
  /// and values represent fields' value
  final OnSubmit onSubmit;

  /// URL for foreignkey
  /// foreignkey field will use this to get editing data
  /// Default is http://0.0.0.0
  final String url;

  /// Round corner of text field
  final bool rounded;

  /// Whether show submit button
  final bool showSubmitButton;

  /// Whether use dropdown button instead of using
  /// another page to show choices.
  /// This will only apply for the select field,
  /// but not foreign key field based on current
  /// implementation. Default is false
  final bool useDropdownButton;

  final Dio networkProvider = Dio();

  JSONSchemaForm({
    @required this.schema,
    this.filled = false,
    this.onSubmit,
    this.icons,
    this.actions,
    this.values,
    this.rounded = false,
    this.schemaName,
    this.controller,
    this.url = "http://0.0.0.0",
    this.showSubmitButton = true,
    this.useDropdownButton = false,
    this.onFileUpload,
    this.useDialog = false,
    @required this.onFetchingSchema,
    @required this.onFetchingforeignKeyChoices,
    @required this.onAddforeignKeyField,
    @required this.onUpdateforeignKeyField,
    @required this.onDeleteforeignKeyField,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<NetworkProvider>(
          create: (_) => NetworkProvider(
            networkProvider: networkProvider,
            url: url,
          ),
        )
      ],
      child: JSONForm(
        filled: filled,
        schema: schema,
        schemaName: schemaName,
        onSubmit: onSubmit,
        icons: icons,
        actions: actions,
        values: values,
        rounded: rounded,
        controller: controller,
        useDialog: useDialog,
        showSubmitButton: showSubmitButton,
        useDropdownButton: useDropdownButton,
        onFetchingSchema: onFetchingSchema,
        onFetchforeignKeyChoices: onFetchingforeignKeyChoices,
        onAddforeignKeyField: onAddforeignKeyField,
        onUpdateforeignKeyField: onUpdateforeignKeyField,
        onDeleteforeignKeyField: onDeleteforeignKeyField,
        onFileUpload: onFileUpload,
      ),
    );
  }
}
