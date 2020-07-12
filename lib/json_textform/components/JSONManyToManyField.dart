import 'package:flutter/material.dart';
import 'package:json_schema_form/json_schema_form.dart';
import 'package:json_schema_form/json_textform/components/pages/ManyToManySelectionPage.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/utils-components/OutlineButtonContainer.dart';
import 'package:provider/provider.dart';

import '../JSONForm.dart';

typedef void OnChange(List<Choice> choice);

class JSONManyToManyField extends StatelessWidget {
  final OnDeleteforeignKeyField onDeleteforeignKeyField;
  final OnUpdateforeignKeyField onUpdateforeignKeyField;
  final OnAddforeignKeyField onAddforeignKeyField;
  final OnFetchingSchema onFetchingSchema;
  final OnFetchforeignKeyChoices onFetchingforeignKeyChoices;
  final OnFileUpload onFileUpload;
  final bool filled;
  final Schema schema;
  final OnChange onSaved;
  final bool showIcon;
  final bool isOutlined;
  final List<FieldAction<dynamic>> actions;
  final List<FieldIcon> icons;
  final bool useDialog;

  JSONManyToManyField({
    @required this.useDialog,
    @required this.schema,
    @required this.onAddforeignKeyField,
    @required this.onFetchingforeignKeyChoices,
    @required this.onUpdateforeignKeyField,
    @required this.onFetchingSchema,
    @required this.actions,
    @required this.icons,
    @required this.onFileUpload,
    @required this.onDeleteforeignKeyField,
    this.onSaved,
    this.showIcon = true,
    this.isOutlined = false,
    this.filled,
  });

  @override
  Widget build(BuildContext context) {
    NetworkProvider networkProvider = Provider.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: OutlineButtonContainer(
        isOutlined: isOutlined,
        isFilled: isOutlined,
        child: ListTile(
          onTap: () async {
            List<Choice> choices;
            if (useDialog) {
              choices = await showDialog(
                context: context,
                builder: (context) => buildSelectionPage(networkProvider),
              );
            } else {
              choices = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (c) => buildSelectionPage(networkProvider),
                ),
              );
            }

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

  ChangeNotifierProvider<NetworkProvider> buildSelectionPage(
      NetworkProvider networkProvider) {
    return ChangeNotifierProvider(
      create: (context) => NetworkProvider(
        networkProvider: networkProvider.networkProvider,
        url: networkProvider.url,
      ),
      child: ManyToManySelectionPage(
        useDialog: useDialog,
        onDeleteforeignKeyField: onDeleteforeignKeyField,
        onFileUpload: onFileUpload,
        onAddforeignKeyField: onAddforeignKeyField,
        onFetchingforeignKeyChoices: onFetchingforeignKeyChoices,
        onFetchingSchema: onFetchingSchema,
        onUpdateforeignKeyField: onUpdateforeignKeyField,
        schema: schema,
        title: "Select ${schema.label} ",
        name: schema.name,
        actions: actions,
        icons: icons,
        value: schema.choices,
      ),
    );
  }
}
