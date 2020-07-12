import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/components/pages/JSONForignKeyEditField.dart';
import 'package:json_schema_form/json_textform/components/pages/SelectionPage.dart';
import 'package:json_schema_form/json_textform/models/components/Action.dart';
import 'package:json_schema_form/json_textform/models/NetworkProvider.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/models/components/Icon.dart';
import 'package:json_schema_form/json_textform/utils-components/OutlineButtonContainer.dart';
import 'package:provider/provider.dart';

typedef OnSaved(Choice choice);

class JSONForeignkeyField extends StatelessWidget {
  final Schema schema;
  final OnSaved onSaved;
  final bool showIcon;
  final bool isOutlined;
  final bool filled;
  final OnUpdateforeignKeyField onUpdateforeignKeyField;
  final OnAddforeignKeyField onAddforeignKeyField;
  final OnFetchingSchema onFetchingSchema;
  final OnFetchforeignKeyChoices onFetchingforeignKeyChoices;
  final OnFileUpload onFileUpload;
  final OnDeleteforeignKeyField onDeleteforeignKeyField;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  JSONForeignkeyField({
    @required this.schema,
    this.onSaved,
    this.showIcon = true,
    this.isOutlined = false,
    this.icons,
    this.actions,
    @required this.filled,
    @required this.onFetchingSchema,
    @required this.onFetchingforeignKeyChoices,
    @required this.onAddforeignKeyField,
    @required this.onUpdateforeignKeyField,
    @required this.onFileUpload,
    @required this.onDeleteforeignKeyField,
  });

  @override
  Widget build(BuildContext context) {
    NetworkProvider networkProvider = Provider.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: OutlineButtonContainer(
              isFilled: filled,
              isOutlined: isOutlined,
              child: ListTile(
                trailing: Icon(
                  Icons.expand_more,
                  color: Theme.of(context).iconTheme.color,
                ),
                title: Text("Select ${schema.label}"),
                subtitle: Text("${schema.choice?.label}"),
                onTap: () async {
                  List<Choice> choices = await onFetchingforeignKeyChoices(
                      schema.extra.relatedModel);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) {
                        return SelectionPage(
                          onSelected: (value) {
                            if (this.onSaved != null) {
                              this.onSaved(value);
                            }
                          },
                          title: "Select ${schema.label}",
                          selections: choices,
                          value: schema.value,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: RawMaterialButton(
              elevation: 0,
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
              fillColor: Colors.blue,
              shape: new CircleBorder(),
              onPressed: () async {
                /// Add new field
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (ctx) {
                    return ChangeNotifierProvider.value(
                      value: networkProvider,
                      child: JSONforeignKeyEditField(
                        onAddforeignKeyField: onAddforeignKeyField,
                        onUpdateforeignKeyField: onUpdateforeignKeyField,
                        onFetchingSchema: onFetchingSchema,
                        onFetchingforeignKeyChoices:
                            onFetchingforeignKeyChoices,
                        onFileUpload: onFileUpload,
                        onDeleteforeignKeyField: onDeleteforeignKeyField,
                        isOutlined: isOutlined,
                        title: "Add ${schema.label}",
                        path: schema.extra.relatedModel,
                        isEdit: false,
                        actions: actions,
                        name: schema.name,
                        icons: icons,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
          Expanded(
            child: RawMaterialButton(
              elevation: 0,
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              fillColor: schema.choice == null ? Colors.grey : Colors.blue,
              shape: new CircleBorder(),
              onPressed: schema.choice == null
                  ? null
                  : () async {
                      /// Edit current field
                      ReturnChoice choice = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) {
                          return ChangeNotifierProvider<NetworkProvider>(
                            create: (_) => NetworkProvider(
                              networkProvider: networkProvider.networkProvider,
                              url: networkProvider.url,
                            ),
                            child: JSONforeignKeyEditField(
                              onDeleteforeignKeyField: onDeleteforeignKeyField,
                              onFileUpload: onFileUpload,
                              onAddforeignKeyField: onAddforeignKeyField,
                              onUpdateforeignKeyField: onUpdateforeignKeyField,
                              onFetchingSchema: onFetchingSchema,
                              onFetchingforeignKeyChoices:
                                  onFetchingforeignKeyChoices,
                              isOutlined: isOutlined,
                              title: "Edit ${schema.label}",
                              path: schema.extra.relatedModel,
                              isEdit: true,
                              id: schema.choice.value,
                              actions: actions,
                              name: schema.name,
                              icons: icons,
                            ),
                          );
                        }),
                      );
                      if (choice != null) {
                        onSaved(choice.choice);
                      }
                    },
            ),
          ),
          // Expanded(
          //   child: RawMaterialButton(
          //     elevation: 0,
          //     child: Icon(
          //       Icons.remove,
          //       color: Colors.white,
          //     ),
          //     fillColor: Colors.blue,
          //     shape: new CircleBorder(),
          //     onPressed: () {},
          //   ),
          // )
        ],
      ),
    );
  }
}
