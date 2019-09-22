// // This is a basic Flutter widget test.
// //
// // To perform an interaction with a widget in your test, use the WidgetTester
// // utility that Flutter provides. For example, you can send tap and scroll
// // gestures. You can also use WidgetTester to find child widgets in the widget
// // tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/JSONSchemaForm.dart';
import 'package:json_schema_form/components/JSONSelectField.dart';
import 'package:json_schema_form/components/JSONTextFormField.dart';
import 'package:json_schema_form/models/Schema.dart';

void main() {
  testWidgets('Test selection field', (WidgetTester tester) async {
    Schema schema = Schema(
        isRequired: false, value: "value", label: "hello", name: "hello");

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: JSONSelectField(
            schema: schema,
          ),
        ),
      ),
    );
    expect(find.text("Select hello"), findsOneWidget);
    expect(find.byKey(Key("selection-field")), findsOneWidget);
    final ListTile selectionField =
        tester.widget(find.byKey(Key("selection-field")));
    // since we didn't provide the choices
    // ontap shoule be null
    expect(selectionField.onTap, null);
  });

  testWidgets('Test selection field with value', (WidgetTester tester) async {
    Schema schema = Schema(
      isRequired: false,
      value: "value",
      label: "hello",
      name: "hello",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: JSONSelectField(
            schema: schema,
          ),
        ),
      ),
    );
    expect(find.text("value"), findsOneWidget);
  });

  testWidgets('Test selection with selection', (WidgetTester tester) async {
    Schema schema = Schema(
      isRequired: false,
      value: "value",
      label: "hello",
      name: "hello",
      extra: Extra(
        choices: [Choice(label: "abc", value: "abc")],
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: JSONSelectField(
            schema: schema,
          ),
        ),
      ),
    );
    expect(find.text("Select hello"), findsOneWidget);
    expect(find.byKey(Key("selection-field")), findsOneWidget);
    final ListTile selectionField =
        tester.widget(find.byKey(Key("selection-field")));
    // since we didn't provide the choices
    // ontap shoule be null
    expect(selectionField.onTap, isNotNull);
  });

  testWidgets('Test text field', (WidgetTester tester) async {
    Schema schema = Schema(
      isRequired: false,
      value: "value",
      label: "hello",
      name: "hello",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: JSONTextFormField(
            schema: schema,
          ),
        ),
      ),
    );
    expect(find.byKey(Key("textfield")), findsOneWidget);
    TextFormField textfield = tester.widget(find.byKey(Key("textfield")));
    expect(textfield.controller.text, "value");
  });

  testWidgets('Test text field with default value',
      (WidgetTester tester) async {
    Schema schema = Schema(
      isRequired: false,
      extra: Extra(defaultValue: "abc"),
      label: "hello",
      name: "hello",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: JSONTextFormField(
            schema: schema,
          ),
        ),
      ),
    );
    expect(find.byKey(Key("textfield")), findsOneWidget);
    TextFormField textfield = tester.widget(find.byKey(Key("textfield")));
    expect(textfield.controller.text, "abc");
  });

  testWidgets('Test text field with default value and value',
      (WidgetTester tester) async {
    Schema schema = Schema(
      isRequired: false,
      value: "cde",
      extra: Extra(defaultValue: "abc"),
      label: "hello",
      name: "hello",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: JSONTextFormField(
            schema: schema,
          ),
        ),
      ),
    );
    expect(find.byKey(Key("textfield")), findsOneWidget);
    TextFormField textfield = tester.widget(find.byKey(Key("textfield")));
    expect(textfield.controller.text, "cde");
  });

  testWidgets('Test if only schema provided', (WidgetTester tester) async {
    List<Map<String, dynamic>> schema = [
      {
        "label": "Name",
        "readonly": false,
        "extra": {},
        "name": "name",
        "widget": "number",
        "required": false,
        "translated": false,
        "validations": {}
      },
      {
        "label": "author",
        "readonly": true,
        "extra": {"related_model": "storage-management/author"},
        "name": "author_name",
        "widget": "foreignkey",
        "required": false,
        "translated": false,
        "validations": {}
      }
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: JSONSchemaForm(
            schema: schema,
          ),
        ),
      ),
    );
    expect(find.byKey(Key("textfield")), findsOneWidget);
  });
}
