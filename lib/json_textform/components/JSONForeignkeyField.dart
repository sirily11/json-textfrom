import 'package:flutter/material.dart';
import '../JSONForm.dart';
import '../components/pages/JSONForignKeyEditField.dart';
import '../components/pages/SelectionPage.dart';
import '../models/components/Action.dart';
import '../models/NetworkProvider.dart';
import '../models/Schema.dart';
import '../models/components/Icon.dart';
import '../utils-components/OutlineButtonContainer.dart';
import 'package:provider/provider.dart';

typedef OnSaved(Choice choice);

class JSONForeignkeyField extends StatelessWidget {
  final bool useDialog;
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
  final OnSearch onSearch;
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
    @required this.onSearch,
    @required this.useDialog,
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
                  FocusScope.of(context).requestFocus(FocusNode());
                  List<Choice> choices = await onFetchingforeignKeyChoices(
                      schema.extra.relatedModel);
                  if (useDialog) {
                    showDialog(
                      context: context,
                      builder: (context) => buildSelectionPage(choices),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return buildSelectionPage(choices);
                        },
                      ),
                    );
                  }
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
                FocusScope.of(context).requestFocus(FocusNode());

                /// Add new field
                if (useDialog) {
                  await showDialog(
                    context: context,
                    builder: (context) => buildAddView(networkProvider),
                  );
                } else {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) {
                      return buildAddView(networkProvider);
                    }),
                  );
                }
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
                      FocusScope.of(context).requestFocus(FocusNode());

                      /// Edit current field
                      ReturnChoice choice;
                      if (useDialog) {
                        choice = await showDialog(
                          context: context,
                          builder: (context) => buildEditView(networkProvider),
                        );
                      } else {
                        choice = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (ctx) {
                            return buildEditView(networkProvider);
                          }),
                        );
                      }

                      if (choice != null) {
                        onSaved(choice.choice);
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }

  SelectionPage buildSelectionPage(List<Choice> choices) {
    return SelectionPage(
      schema: schema,
      onSearch: onSearch,
      useDialog: useDialog,
      onSelected: (value) {
        if (this.onSaved != null) {
          this.onSaved(value);
        }
      },
      title: "Select ${schema.label}",
      selections: choices,
      value: schema.value,
    );
  }

  Widget buildEditView(NetworkProvider networkProvider) {
    return ChangeNotifierProvider<NetworkProvider>(
      create: (_) => NetworkProvider(
        networkProvider: networkProvider.networkProvider,
        url: networkProvider.url,
      ),
      child: JSONforeignKeyEditField(
        filled: filled,
        useDialog: useDialog,
        onDeleteforeignKeyField: onDeleteforeignKeyField,
        onFileUpload: onFileUpload,
        onAddforeignKeyField: onAddforeignKeyField,
        onSearch: onSearch,
        onUpdateforeignKeyField: onUpdateforeignKeyField,
        onFetchingSchema: onFetchingSchema,
        onFetchingforeignKeyChoices: onFetchingforeignKeyChoices,
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
  }

  Widget buildAddView(NetworkProvider networkProvider) {
    return ChangeNotifierProvider.value(
      value: networkProvider,
      child: JSONforeignKeyEditField(
        filled: filled,
        useDialog: useDialog,
        onAddforeignKeyField: onAddforeignKeyField,
        onUpdateforeignKeyField: onUpdateforeignKeyField,
        onFetchingSchema: onFetchingSchema,
        onFetchingforeignKeyChoices: onFetchingforeignKeyChoices,
        onFileUpload: onFileUpload,
        onSearch: onSearch,
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
  }
}
