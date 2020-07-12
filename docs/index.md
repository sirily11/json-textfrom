<!-- @format -->

# Welcome to JSON Shcema Flutter

This is the plugin for flutter using JSON Schema to define the form itself.
It supports:

- Textfield
- [Selection field](selection/index.md)
- [foreignkey field](foreignkey/index.md)
- Qrcode scanning
- DateTime Field
- Custom field icon and action

## Basic usage

```dart
JSONSchemaForm(
    rounded: true,
    controller: controller,
    schema: (snapshot.data['fields'] as List)
        .map((s) => s as Map<String, dynamic>)
        .toList()
)
```

## Pre-defined value

use your schema's name field as key, and then put values. And then it will use the pre-defined value as value in your schema value instead of blank value.

```dart
JSONSchemaForm(
    rounded: true,
    controller: controller,
    schema: (snapshot.data['fields'] as List)
        .map((s) => s as Map<String, dynamic>)
        .toList(),
    values: {
            "author_id": {"label": "some label", "value": 2},
            "name": "abc",
            "time": DateTime(2016, 1, 2, 1).toIso8601String(),
    },
)
```

## Add icons

if you want to add leading icon for each field, you can customize the icons field. For example, suppose you have schema like

```json
{
  "label": "Item Name",
  "readonly": false,
  "extra": { "help": "Please Enter your item name", "default": "" },
  "name": "name",
  "widget": "text",
  "required": true,
  "translated": false,
  "validations": {
    "length": { "maximum": 1024 }
  }
}
```

and you want to add icon for this field, then you can define the schema like this

```dart
JSONSchemaForm(
    rounded: true,
    controller: controller,
    schema: (snapshot.data['fields'] as List)
        .map((s) => s as Map<String, dynamic>)
        .toList(),
    icons: [
        FieldIcon(schemaName: "name", iconData: Icons.title),
    ]
)
```

schemaName is the same as the field "name" in your json schema.

## Add actions

To add actions for your form, define actions field. For example, your schema looks like this:

```json
{
  "label": "Item Name",
  "readonly": false,
  "extra": { "help": "Please Enter your item name", "default": "" },
  "name": "name",
  "widget": "text",
  "required": true,
  "translated": false,
  "validations": {
    "length": { "maximum": 1024 }
  }
}
```

Then you can define your schema like this

```dart
JSONSchemaForm(
    rounded: true,
    controller: controller,
    schema: (snapshot.data['fields'] as List)
        .map((s) => s as Map<String, dynamic>)
        .toList(),
    actions: [
        FieldAction<File>(
            schemaName: "name",
            actionTypes: ActionTypes.image,
            actionDone: ActionDone.getImage,
            onDone: (File file) async {
            if (file is File) {
                print(file);
            }
            return file;
        }),
    ]
)
```

This will take a image by using your device's camera and then return the image.

Currently support following action types:

- image
- qrcode

And action done actions:

- getInput
- getImage

|          | image                                        | qrcode            |
| -------- | -------------------------------------------- | ----------------- |
| getInput | use your custom onDone function to get value | get qr code value |
| getImage | return image value                           |                   |

also, you can define your own custom onDone function to do the image classification. For example, following code will return "abc" after the image was taken.

```dart
 FieldAction<File>(
        schemaName: "name",
        schemaFor: "category_id",
        actionTypes: ActionTypes.image,
        actionDone: ActionDone.getInput,
        onDone: (File file) async {
        if (file is File) {
            print(file);
        }
        return "abc";
})
```

More information about actions, please refer the docs on [foreignKey](foreignkey/index.md)

## Retriving data

### Use onSubmit Function

if you want to get the data after user click on onSubmit button, then you can use onSubmit field to get data. This function will be called after user click on the submit button.

```dart
JSONSchemaForm(
    rounded: true,
    controller: controller,
    schema: (snapshot.data['fields'] as List)
        .map((s) => s as Map<String, dynamic>)
        .toList(),
    onSubmit: (value) async {
        print(value);
    },
)
```

### Use controller

However, if you want to have you own submit button and get the value from the schema, you can use controller.

First, define the controller

```dart
JSONSchemaController controller = JSONSchemaController();
```

Then, use the controller

```dart
JSONSchemaForm(
    rounded: true,
    controller: controller,
    schema: (snapshot.data['fields'] as List)
        .map((s) => s as Map<String, dynamic>)
        .toList(),
)
```

Finally, use the controller.

```dart
 var value = await this.controller.onSubmit(context);
```
