import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form_example/menubutton/MenuButton.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

class CheckBoxDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final schema = [
      {
        "label": "show in folder",
        "readonly": false,
        "extra": {"default": true, "help": "Select your widget"},
        "name": "show_in_folder",
        "widget": "checkbox",
        "required": false,
        "translated": false,
        "validations": {}
      },
    ];

    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("CheckBox Preview"),
      ),
      body: Stack(
        children: <Widget>[
          JSONSchemaForm(
            schema: schema,
            showSubmitButton: homeProvider.showSubmitButton,
            filled: homeProvider.isFilled,
            rounded: homeProvider.isRounded,
            onFetchingSchema: null,
            onFetchingforeignKeyChoices: null,
            onAddforeignKeyField: null,
            onUpdateforeignKeyField: null,
            onDeleteforeignKeyField: null,
          ),
          MenuButton(),
        ],
      ),
    );
  }
}
