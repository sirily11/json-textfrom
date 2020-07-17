import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import '../../models/Schema.dart';

class SelectionPage extends StatefulWidget {
  final Schema schema;
  final OnSearch onSearch;
  final bool useDialog;
  final String title;
  final List<Choice> selections;
  final Function onSelected;
  final bool isOutlined;

  /// Current selected value
  final dynamic value;

  SelectionPage({
    @required this.onSearch,
    @required this.selections,
    this.onSelected,
    @required this.title,
    this.isOutlined = false,
    @required this.useDialog,
    this.schema,
    this.value,
  });

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  dynamic _selectedValue;
  List<Choice> selections = [];
  bool isLoading = false;
  dynamic error;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
    selections = widget.selections;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useDialog) {
      return AlertDialog(
        title: Text("${widget.title}"),
        content: Container(
          width: 600,
          child: buildBody(),
        ),
        actions: [
          FlatButton(
            key: Key("Back"),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          FlatButton(
            onPressed: () {
              _onDone(selections, context);
            },
            child: Text("Ok"),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.title}"),
        leading: BackButton(
          key: Key("Back"),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              _onDone(selections, context);
            },
          )
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        buildTextField(),
        Expanded(
          child: Builder(builder: (context) {
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
            return Scrollbar(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selections.length,
                itemBuilder: (ctx, index) {
                  Choice selection = selections[index];
                  bool checked = selection.value == _selectedValue;
                  return RadioListTile(
                    key: Key("${selection.label}-$checked"),
                    groupValue: _selectedValue,
                    title: Text("${selection.label}"),
                    value: selection.value,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedValue = newValue;
                      });
                    },
                  );
                },
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget buildTextField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(labelText: "Search..."),
        onChanged: (value) async {
          if (widget.onSearch == null) {
            // use default filter
            setState(() {
              this.selections = _defaultSearch(value);
            });
          } else {
            try {
              setState(() {
                isLoading = true;
              });
              var results = await widget.onSearch(
                  widget.schema?.extra?.relatedModel, value);

              setState(() {
                if (results == null) {
                  this.selections = _defaultSearch(value);
                } else {
                  this.selections = results;
                }
              });
            } catch (err) {
              setState(() {
                error = err;
              });
            } finally {
              setState(() {
                isLoading = false;
              });
            }
          }
        },
      ),
    );
  }

  List<Choice> _defaultSearch(String value) {
    return widget.selections
        .where((s) => value != "" ? s.label.contains(value) : true)
        .toList();
  }

  void _onDone(List<Choice> _list, BuildContext context) {
    if (widget.onSelected != null) {
      widget.onSelected(
        _list.firstWhere((l) => l.value == _selectedValue, orElse: () => null),
      );
    }
    Navigator.pop(context);
  }
}
