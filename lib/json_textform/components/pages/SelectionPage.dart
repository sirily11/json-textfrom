import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

class SelectionPage extends StatefulWidget {
  final bool useDialog;
  final String title;
  final List<Choice> selections;
  final Function onSelected;
  final bool isOutlined;

  /// Current selected value
  final dynamic value;

  SelectionPage({
    @required this.selections,
    this.onSelected,
    @required this.title,
    this.isOutlined = false,
    @required this.useDialog,
    this.value,
  });

  @override
  _SelectionPageState createState() => _SelectionPageState();
}

class _SelectionPageState extends State<SelectionPage> {
  String _filterText = "";
  dynamic _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    List<Choice> _list = widget.selections
        .where((s) => _filterText != "" ? s.label.contains(_filterText) : true)
        .toList();

    if (widget.useDialog) {
      return AlertDialog(
        title: Text("${widget.title}"),
        content: Container(
          width: 600,
          child: buildBody(_list),
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
              _onDone(_list, context);
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
              _onDone(_list, context);
            },
          )
        ],
      ),
      body: buildBody(_list),
    );
  }

  Widget buildBody(List<Choice> _list) {
    return Scrollbar(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _list.length + 1,
        itemBuilder: (ctx, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(labelText: "Search..."),
                onChanged: (value) {
                  setState(() {
                    _filterText = value;
                  });
                },
              ),
            );
          }
          Choice selection = _list[index - 1];
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
