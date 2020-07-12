<!-- @format -->

# Flutter JSON Form

![Flutter test](https://github.com/sirily11/json-textfrom/workflows/Flutter%20test/badge.svg) [![codecov](https://codecov.io/gh/sirily11/json-textfrom/branch/master/graph/badge.svg)](https://codecov.io/gh/sirily11/json-textfrom)

## Setup

Before you use this plugin, you need to setup your ios/android project inorder to use file field(File upload).

Reference [this page](https://pub.dev/packages/file_picker#-readme-tab-) to setup.

## Introduction

This is the plugin for flutter using JSON Schema to define the form itself.
It supports:

- Textfield
- Selection Field
- foreignkey Field
- qrcode scanning
- Checkbox Field
- DateTime Field
- custom field icon and action
- ManyToMany Field
- File Field

# Getting start

> Important! The foreign key field is using Django Rest Framework with DRF-schema-adapter. All the schema's structures are based on it. You can take a look what the structure is on this [page](https://drf-schema-adapter.readthedocs.io/en/latest/drf_auto_endpoint/metadata/)

## First prepare data

```dart
Map<String, dynamic> itemJSONData = {
  "fields": [
    {
      "label": "ID",
      "readonly": true,
      "extra": {},
      "name": "id",
      "widget": "number",
      "required": false,
      "translated": false,
      "validations": {}
    },
    {
      "label": "Item Name",
      "readonly": false,
      "extra": {"help": "Please Enter your item name", "default": ""},
      "name": "name",
      "widget": "text",
      "required": true,
      "translated": false,
      "validations": {
        "length": {"maximum": 1024}
      }
    }]
```

## put the data into JSONSchemaForm

```dart

JSONSchemaForm(
                schema: (snapshot.data['fields'] as List)
                    .map((s) => s as Map<String, dynamic>)
                    .toList(),
                icons: [
                  FieldIcon(schemaName: "name", iconData: Icons.title),
                ],
                actions: [
                  FieldAction(
                      schemaName: "qr_code",
                      actionTypes: ActionTypes.qrScan,
                      actionDone: ActionDone.getInput)
                ],
                onSubmit: (value) {
                  print(value);
                },
              ),

```

As you can see, you can provide actions and icons based on the name property in the schema's data.

## More tutorials

read more on [this](https://sirily11.github.io/json-textfrom/)
