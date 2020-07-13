import 'package:flutter/material.dart';
import '../../json_schema_form.dart';
import '../components/pages/ManyToManySelectionPage.dart';
import '../models/Schema.dart';
import 'package:json_schema_form/json_textform/utils-components/OutlineButtonContainer.dart';
import 'package:provider/provider.dart';

import '../JSONForm.dart';

typedef void OnChange(List<Choice> choice);

class JSONManyToManyField extends StatelessWidget {
  final OnSearch onSearch;
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
    @required this.onSearch,
    @required this.onDeleteforeignKeyField,
    this.onSaved,
    this.showIcon = true,
    this.isOutlined = false,
    @required this.filled,
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
            FocusScope.of(context).requestFocus(FocusNode());
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
        filled: filled,
        useDialog: useDialog,
        onSearch: onSearch,
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
