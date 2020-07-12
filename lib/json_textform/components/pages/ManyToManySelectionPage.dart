import 'package:flutter/material.dart';

import 'package:json_schema_form/json_textform/models/NetworkProvider.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/models/components/Action.dart';
import 'package:json_schema_form/json_textform/models/components/Icon.dart';
import 'package:provider/provider.dart';

import '../../JSONForm.dart';
import 'JSONForignKeyEditField.dart';

class ManyToManySelectionPage extends StatefulWidget {
  final OnDeleteforeignKeyField onDeleteforeignKeyField;
  final OnFileUpload onFileUpload;
  final OnUpdateforeignKeyField onUpdateforeignKeyField;
  final OnAddforeignKeyField onAddforeignKeyField;
  final OnFetchingSchema onFetchingSchema;
  final OnFetchforeignKeyChoices onFetchingforeignKeyChoices;
  final Schema schema;
  final String title;
  final bool isOutlined;

  /// Page's name
  /// This one is different from the title
  /// and will be used to merge actions and icons.
  final String name;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  /// Current selected value
  final List<Choice> value;

  ManyToManySelectionPage({
    @required this.title,
    this.isOutlined = false,
    this.value,
    @required this.onFetchingforeignKeyChoices,
    @required this.onAddforeignKeyField,
    @required this.onFetchingSchema,
    @required this.onUpdateforeignKeyField,
    @required this.schema,
    @required this.actions,
    @required this.icons,
    @required this.name,
    @required this.onFileUpload,
    @required this.onDeleteforeignKeyField,
  });

  @override
  _ManyToManySelectionPageState createState() =>
      _ManyToManySelectionPageState();
}

class _ManyToManySelectionPageState extends State<ManyToManySelectionPage> {
  String _filterText = "";
  List<Choice> selections = [];
  List<Choice> avaliableSelections = [];
  bool isLoading = true;
  dynamic error;

  @override
  void initState() {
    super.initState();
    init();

    selections = (widget.value ?? [])
        .map((e) => e.toJson())
        .map((e) => Choice.fromJSON(e))
        .toList();
  }

  Future<void> init() async {
    try {
      var selections = await widget
          .onFetchingforeignKeyChoices(widget.schema.extra.relatedModel);
      setState(() {
        avaliableSelections = selections;
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        error = err;
        isLoading = false;
      });
    }
  }

  Future<void> _onAdd() async {
    NetworkProvider networkProvider = Provider.of(context, listen: false);
    ReturnChoice response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: networkProvider,
          child: JSONforeignKeyEditField(
            onDeleteforeignKeyField: widget.onDeleteforeignKeyField,
            title: "Add ${widget.schema.label}",
            isEdit: false,
            icons: widget.icons,
            actions: widget.actions,
            isOutlined: widget.isOutlined,
            path: widget.schema.extra.relatedModel,
            name: widget.schema.name,
            onFetchingSchema: widget.onFetchingSchema,
            onFetchingforeignKeyChoices: widget.onFetchingforeignKeyChoices,
            onAddforeignKeyField: widget.onAddforeignKeyField,
            onUpdateforeignKeyField: widget.onUpdateforeignKeyField,
            onFileUpload: widget.onFileUpload,
          ),
        ),
      ),
    );

    if (response != null) {
      await init();
    }
  }

  Future<void> _onUpdate(Choice choice) async {
    NetworkProvider networkProvider = Provider.of(context, listen: false);
    ReturnChoice response = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (context) => NetworkProvider(
            networkProvider: networkProvider.networkProvider,
            url: networkProvider.url,
          ),
          child: JSONforeignKeyEditField(
            title: "Edit ${widget.schema.label}",
            isEdit: true,
            id: choice.value,
            icons: widget.icons,
            actions: widget.actions,
            isOutlined: widget.isOutlined,
            path: widget.schema.extra.relatedModel,
            name: widget.schema.name,
            onFetchingSchema: widget.onFetchingSchema,
            onFetchingforeignKeyChoices: widget.onFetchingforeignKeyChoices,
            onAddforeignKeyField: widget.onAddforeignKeyField,
            onUpdateforeignKeyField: widget.onUpdateforeignKeyField,
            onFileUpload: widget.onFileUpload,
            onDeleteforeignKeyField: widget.onDeleteforeignKeyField,
          ),
        ),
      ),
    );

    if (response != null) {
      await init();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          key: Key("Back"),
          onPressed: () {
            Navigator.pop(context, null);
          },
        ),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              Navigator.pop(context, selections);
            },
          )
        ],
      ),
      body: Builder(builder: (context) {
        if (isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (error != null) {
          return Center(
            child: Text("$error"),
          );
        }

        List<Choice> choices = avaliableSelections
            .where(
              (element) => element.label.contains(_filterText),
            )
            .toList();

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      key: Key("Filter"),
                      decoration: InputDecoration(labelText: "Search..."),
                      onChanged: (value) {
                        setState(() {
                          _filterText = value;
                        });
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: _onAdd,
                    icon: Icon(Icons.add),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: choices.length,
                itemBuilder: (ctx, index) {
                  Choice selection = choices[index];
                  bool checked = selections.contains(selection);
                  return CheckboxListTile(
                    key: Key("Checkbox-${selection.label}-$checked"),
                    title: Row(
                      children: <Widget>[
                        IconButton(
                          key: Key("Edit"),
                          onPressed: () async {
                            await _onUpdate(selection);
                          },
                          icon: Icon(
                            Icons.edit,
                          ),
                        ),
                        Text(selection.label),
                      ],
                    ),
                    value: checked,
                    onChanged: (checked) {
                      if (checked) {
                        selections.add(selection);
                      } else {
                        selections.remove(selection);
                      }

                      setState(() {
                        selections = selections;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
