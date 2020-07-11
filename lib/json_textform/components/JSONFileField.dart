import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/models/components/FileFieldValue.dart';
import 'package:json_schema_form/json_textform/utils-components/OutlineButtonContainer.dart';

import '../JSONForm.dart';

typedef void OnChange(FileFieldValue value);

class JSONFileField extends StatelessWidget {
  final OnFileUpload onFileUpload;
  final Schema schema;
  final OnChange onSaved;
  final bool showIcon;
  final bool isOutlined;
  final bool filled;
  final Key key;

  JSONFileField({
    @required this.schema,
    @required this.onFileUpload,
    this.key,
    this.onSaved,
    this.showIcon = true,
    this.isOutlined = false,
    this.filled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FileFieldValue value;
    if (schema.value == null) {
      value = FileFieldValue();
    } else if (schema.value is! FileFieldValue) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: Text(
          "Value is not supported",
          style: TextStyle(color: Colors.red),
        ),
      );
    } else {
      value = schema.value;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: OutlineButtonContainer(
        isFilled: filled,
        isOutlined: isOutlined,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(schema.label),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Wrap(
                      children: <Widget>[
                        if (value.path != null)
                          Chip(
                            label: Text(
                              "Old: ${value.path}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                decoration: value.willClear
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            deleteIcon: !value.willClear
                                ? Icon(Icons.cancel)
                                : Icon(Icons.restore),
                            onDeleted: () {
                              if (value.willClear) {
                                value.restoreOld();
                              } else {
                                value.clearOld();
                              }
                              onSaved(value);
                            },
                          ),
                        if (value.file != null)
                          Chip(
                            label: Text(
                              "New: ${value.file.path}",
                              maxLines: 1,
                            ),
                            onDeleted: () {
                              value.clearNew();
                              onSaved(value);
                            },
                          )
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      File file;
                      if (onFileUpload != null) {
                        file = await onFileUpload(schema.name);
                      } else {
                        file = await FilePicker.getFile();
                      }
                      value.file = file;
                      if (file != null) {
                        onSaved(value);
                      }
                    },
                    icon: Icon(Icons.file_upload),
                  )
                ],
              ),
              Divider(
                color: Theme.of(context).textTheme.bodyText1.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
