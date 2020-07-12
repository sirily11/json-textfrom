import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form_example/menubutton/MenuButton.dart';
import 'package:json_schema_form_example/model/HomeProvider.dart';
import 'package:provider/provider.dart';

class DatetimeFieldDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final schema = [
      {
        "label": "created time",
        "readonly": false,
        "extra": {},
        "name": "created_time",
        "widget": "datetime",
        "required": false,
        "translated": false,
        "validations": {}
      }
    ];

    HomeProvider homeProvider = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("CheckBox Preview"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
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
      ),
    );
  }
}
