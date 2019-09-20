import 'package:flutter/material.dart';
import 'package:json_textform/json_form/Schema.dart';

class JSONTextFormField extends StatelessWidget {
  final Schema schema;
  final Function onSaved;
  final bool showIcon;
  final bool isOutlined;

  JSONTextFormField(
      {@required this.schema,
      this.onSaved,
      this.showIcon = true,
      this.isOutlined = false});

  String validation(String value) {
    switch (schema.widget) {
      case WidgetType.number:
        break;
      default:
    }
  }

  Widget _renderIcon() {
    switch (schema.label) {
      case "email":
        return Icon(Icons.email);
      case "password":
        return Icon(Icons.keyboard);
      default:
        return Icon(Icons.people);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
        child: TextFormField(
          initialValue: schema.extra?.defaultValue?.toString() ?? "",
          validator: this.validation,
          maxLength: schema.validation?.length?.maximum,
          obscureText: schema.name == "password",
          decoration: InputDecoration(
            helperText: schema.extra.helpText,
            labelText: schema.label,
            prefixIcon: this.showIcon ? _renderIcon() : null,
            border: isOutlined == true
                ? OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                  )
                : null,
          ),
          onSaved: this.onSaved,
        ),
      ),
    );
  }
}
