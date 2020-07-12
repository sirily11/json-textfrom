<!-- @format -->

# foreign Key

## Basic usage

if you have a schema like this

```json
{
  "label": "category",
  "readonly": true,
  "extra": { "related_model": "storage-management/category" },
  "name": "category_name",
  "widget": "foreignkey",
  "required": false,
  "translated": false,
  "validations": {}
}
```

and dart code like this:

```dart
JSONSchemaForm(
    schema: (snapshot.data['fields'] as List)
        .map((s) => s as Map<String, dynamic>)
        .toList(),
    url: "http://192.168.1.114:8000",
);
```

then, JSONSchemaForm will automatically go to http://192.168.1.114:8000/**storage_management/category** by using **option** request to fetch the schema for category.

> important notes: The foreignkey field is based on the implementation on django's schema,which will replace **storage-management/category** to **storage_management/category**.

## Pre-defined value

suppose you have schema above where your foreignkey has name **category_name**. To set pre-define value for the foreignkey, use following syntax. schema's name as key, and value is a map where it has two field, one is label and another is value.

- label: a text represents the selected field's name which used to display on the main screen.

- value: a field represents the actual selected value which used to display on the foreignkey selection page.

For example, if you have label as "hello", and value is 2. When you on the main screen (before click on select button), it will display "Select category hello". And after you get into the detail page, it will mark radio button hello which has value 2 selected.

```dart
JSONSchemaForm(
    rounded: true,
    controller: controller,
    schema: (snapshot.data['fields'] as List)
        .map((s) => s as Map<String, dynamic>)
        .toList(),
    values: {
            "category_name": {"label": "some label", "value": 2},
    },
)
```

## Actions and icons

To use actions and icons for foreignkey field (The field displayed after get into the detail page), you need to set schemaFor field. If you want to set the actions/icons for every field with same name, you can set useGlobally to true.

For example, you have you home schema like this

```json
[
  {
    "label": "category",
    "readonly": false,
    "extra": { "related_model": "storage-management/category" },
    "name": "category_id",
    "widget": "foreignkey",
    "required": false,
    "translated": false,
    "validations": {}
  },
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
]
```

And the schema for you category has the following schema

```json
[
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
]
```

you can define an action for the Item name field (which is inside the category) like this. Note that schemaFor's value is the same as the name field's value in your main schema.

```dart
 FieldAction<File>(
        schemaName: "name",
        schemaFor: "category_id",
        actionTypes: ActionTypes.image,
        actionDone: ActionDone.getInput,
        onDone: (File file) async {

        }
)
```
