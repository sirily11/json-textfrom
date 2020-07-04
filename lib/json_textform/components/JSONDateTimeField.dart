import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

class JSONDateTimeField extends StatefulWidget {
  final Schema schema;
  final Function onSaved;
  final bool isOutlined;
  final bool filled;

  JSONDateTimeField({
    @required this.schema,
    this.onSaved,
    this.isOutlined = false,
    Key key,
    @required this.filled,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _JSONDateTimeFieldState();
  }
}

class _JSONDateTimeFieldState extends State<JSONDateTimeField> {
  TextEditingController _controller;
  DateTime dateTime;

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(JSONDateTimeField oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      init();
    });
  }

  void init() {
    String value = widget.schema.value ??
        widget.schema.extra?.defaultValue?.toString() ??
        "${DateTime.now().toString()}";
    dateTime = DateTime.parse(value);
    _controller = TextEditingController(
        text: "${dateTime.year}-${dateTime.month}-${dateTime.day}");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: TextFormField(
          onChanged: (v) {
            _controller.text =
                "${dateTime.year}-${dateTime.month}-${dateTime.day}";
          },
          onTap: () async {
            DateTime selectedDate = await showDatePicker(
              context: context,
              initialDate: dateTime,
              firstDate: DateTime(1900),
              lastDate: DateTime(2077),
            );
            if (selectedDate != null) {
              setState(() {
                dateTime = selectedDate;
                _controller.text =
                    "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
              });
            }
          },
          key: Key("datetimefield"),
          controller: _controller,
          decoration: InputDecoration(
            filled: widget.filled,
            helperText: widget.schema.extra?.helpText,
            labelText: widget.schema.label,
            prefixIcon: widget.schema.icon != null
                ? Icon(widget.schema.icon.iconData)
                : null,
            border: widget.isOutlined == true
                ? OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  )
                : null,
          ),
          onSaved: (v) {
            this.widget.onSaved(dateTime.toIso8601String());
          },
        ),
      ),
    );
  }
}
