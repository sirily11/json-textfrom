import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_schema_form/models/Action.dart';
import 'package:json_schema_form/models/Schema.dart';

class JSONTextFormField extends StatefulWidget {
  final Schema schema;
  final Function onSaved;
  final bool isOutlined;

  JSONTextFormField(
      {@required this.schema, this.onSaved, this.isOutlined = false, Key key})
      : super(key: key);

  @override
  _JSONTextFormFieldState createState() => _JSONTextFormFieldState();
}

class _JSONTextFormFieldState extends State<JSONTextFormField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    print("Build");
    String value = widget.schema.value ??
        widget.schema.extra?.defaultValue?.toString() ??
        "";

    _controller = TextEditingController(text: value);
  }

  String validation(String value) {
    switch (widget.schema.widget) {
      case WidgetType.number:
        final n = num.tryParse(value);
        if (n == null) {
          return '"$value" is not a valid number';
        }
        break;
      default:
        if ((value == null || value == "") && widget.schema.isRequired) {
          return "This field is required";
        }
    }
  }

  _suffixIconAction({dynamic image, dynamic inputValue}) {
    switch (widget.schema.action.actionDone) {
      case ActionDone.getInput:
        _controller.text = inputValue.toString();
        break;

      case ActionDone.getImage:

        // TODO: Add image support
        break;
    }
  }

  Widget _renderSuffixIcon() {
    if (widget.schema.action != null) {
      switch (widget.schema.action.actionTypes) {
        case ActionTypes.image:
          break;

        case ActionTypes.qrScan:
          return IconButton(
            onPressed: () async {
              try {
                String barcode = await BarcodeScanner.scan();
                _suffixIconAction(inputValue: barcode);
              } on PlatformException catch (e) {
                if (e.code == BarcodeScanner.CameraAccessDenied) {
                } else {}
              } on FormatException {} catch (e) {}
            },
            icon: Icon(Icons.camera_alt),
          );
          break;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: TextFormField(
          onChanged: (value) {
            widget.onSaved(value);
          },
          key: Key("textfield"),
          // controller: _controller,
          initialValue: widget.schema.value ??
              widget.schema.extra?.defaultValue?.toString() ??
              "",
          keyboardType: widget.schema.widget == WidgetType.number
              ? TextInputType.number
              : null,
          validator: this.validation,
          maxLength: widget.schema.validation?.length?.maximum,
          obscureText: widget.schema.name == "password",
          decoration: InputDecoration(
            helperText: widget.schema.extra?.helpText,
            labelText: widget.schema.label,
            prefixIcon: widget.schema.icon != null
                ? Icon(widget.schema.icon.iconData)
                : null,
            suffixIcon: _renderSuffixIcon(),
            border: widget.isOutlined == true
                ? OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  )
                : null,
          ),
          onSaved: this.widget.onSaved,
        ),
      ),
    );
  }
}
