import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

class SelectionPage extends StatefulWidget {
  final String title;
  final List<Choice> selections;
  final Function onSelected;
  final bool isOutlined;

  /// Current selected value
  final dynamic value;

  SelectionPage(
      {@required this.selections,
      this.onSelected,
      @required this.title,
      this.isOutlined = false,
      this.value});

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(
          key: Key("Back"),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
              if (widget.onSelected != null) {
                widget.onSelected(
                  _list.firstWhere((l) => l.value == _selectedValue,
                      orElse: () => null),
                );
              }
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(labelText: "Search..."),
              onChanged: (value) {
                setState(() {
                  _filterText = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _list.length,
              itemBuilder: (ctx, index) {
                Choice selection = _list[index];
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
          ),
        ],
      ),
    );
  }
}
