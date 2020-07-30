import 'package:flutter/material.dart';
import '../components/pages/SelectionPage.dart';
import '../models/Schema.dart';
import '../models/Schema.dart';
import '../utils-components/OutlineButtonContainer.dart';

typedef void OnChange(Choice choice);

class JSONSelectField extends StatelessWidget {
  final bool filled;
  final Schema schema;
  final OnChange onSaved;
  final bool showIcon;
  final bool isOutlined;
  final bool useDialog;

  /// implementation. Default is false
  final bool useDropdownButton;
  final bool useRadioButton;

  JSONSelectField({
    @required this.schema,
    @required this.useDialog,
    @required this.useRadioButton,
    this.onSaved,
    this.showIcon = true,
    this.isOutlined = false,
    this.filled,
    @required this.useDropdownButton,
  });

  @override
  Widget build(BuildContext context) {
    Choice selectedValue = schema?.extra?.choices?.firstWhere(
      (element) => element.value == schema.value,
      orElse: () => null,
    );
    if (useRadioButton != null && useRadioButton) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10),
            child: Text(
              "Select ${schema.label}",
              style:
                  Theme.of(context).textTheme.subtitle1.copyWith(fontSize: 18),
            ),
          ),
          for (var choice in schema?.extra?.choices)
            RadioListTile(
              onChanged: (v) {
                this.onSaved(v);
              },
              groupValue: selectedValue,
              value: choice,
              title: Text("${choice.label}"),
            ),
          Divider(),
        ],
      );
    }

    if (useDropdownButton != null && useDropdownButton) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
        child: Row(
          children: <Widget>[
            if (schema.icon != null)
              Icon(
                schema.icon.iconData,
                color: Theme.of(context).iconTheme.color,
              ),
            Spacer(),
            Expanded(
              flex: 9,
              child: DropdownButton(
                key: Key("Dropdown"),
                hint: Text("Select ${schema.label}"),
                isExpanded: true,
                onChanged: (v) {
                  this.onSaved(v);
                },
                value: selectedValue,
                items: schema?.extra?.choices
                    ?.map(
                      (e) => DropdownMenuItem(
                        key: Key("Dropdown-${e.label}"),
                        value: e,
                        child: Text(e.label),
                      ),
                    )
                    ?.toList(),
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      child: OutlineButtonContainer(
        isFilled: filled,
        isOutlined: isOutlined,
        child: ListTile(
          key: Key("selection-field"),
          leading: schema.icon != null
              ? Icon(
                  schema.icon.iconData,
                  color: Theme.of(context).iconTheme.color,
                )
              : null,
          trailing:
              Icon(Icons.expand_more, color: Theme.of(context).iconTheme.color),
          onTap: schema?.extra?.choices == null
              ? null
              : () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (useDialog) {
                    showDialog(
                      context: context,
                      builder: (context) => buildSelectionPage(),
                    );
                  } else {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) {
                          return buildSelectionPage();
                        },
                      ),
                    );
                  }
                },
          title: Text("Select ${schema.label}"),
          subtitle: Text(schema.value ?? schema?.extra?.defaultValue ?? ""),
        ),
      ),
    );
  }

  SelectionPage buildSelectionPage() {
    return SelectionPage(
      schema: schema,
      onSearch: null,
      useDialog: useDialog,
      onSelected: (value) {
        if (this.onSaved != null) {
          this.onSaved(value);
        }
      },
      title: "Select ${schema.label}",
      selections: schema.extra.choices,
      value: schema.value ?? schema.extra.defaultValue,
    );
  }
}
