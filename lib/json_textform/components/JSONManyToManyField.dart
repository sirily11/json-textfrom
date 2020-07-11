import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart';
import 'package:json_schema_form/json_textform/components/pages/ManyToManySelectionPage.dart';
import 'package:json_schema_form/json_textform/components/pages/SelectionPage.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/utils-components/OutlineButtonContainer.dart';

import '../JSONForm.dart';

typedef void OnChange(List<Choice> choice);

class JSONManyToManyField extends StatelessWidget {
  final OnUpdateForignKeyField onUpdateForignKeyField;
  final OnAddForignKeyField onAddForignKeyField;
  final OnFetchingSchema onFetchingSchema;
  final OnFetchForignKeyChoices onFetchingForignKeyChoices;
  final OnFileUpload onFileUpload;
  final bool filled;
  final Schema schema;
  final OnChange onSaved;
  final bool showIcon;
  final bool isOutlined;
  final List<FieldAction<dynamic>> actions;
  final List<FieldIcon> icons;

  JSONManyToManyField({
    @required this.schema,
    @required this.onAddForignKeyField,
    @required this.onFetchingForignKeyChoices,
    @required this.onUpdateForignKeyField,
    @required this.onFetchingSchema,
    @required this.actions,
    @required this.icons,
    @required this.onFileUpload,
    this.onSaved,
    this.showIcon = true,
    this.isOutlined = false,
    this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: OutlineButtonContainer(
        isOutlined: isOutlined,
        isFilled: isOutlined,
        child: ListTile(
          onTap: () async {
            List<Choice> choices = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (c) => ManyToManySelectionPage(
                  onFileUpload: onFileUpload,
                  onAddForignKeyField: onAddForignKeyField,
                  onFetchingForignKeyChoices: onFetchingForignKeyChoices,
                  onFetchingSchema: onFetchingSchema,
                  onUpdateForignKeyField: onUpdateForignKeyField,
                  schema: schema,
                  title: "Select ${schema.label} ",
                  name: schema.name,
                  actions: actions,
                  icons: icons,
                  value: schema.choices,
                ),
              ),
            );

            if (choices != null) {
              onSaved(choices);
            }
          },
          title: Text("Select ${schema.label}"),
          subtitle: Text("${schema.choices.length} selection"),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
