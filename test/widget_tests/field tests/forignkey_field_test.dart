import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

void main() {
  group("foreign key Field Test", () {
    final editButtonFinder = find.byIcon(Icons.edit);
    final backButtonFinder = find.byKey(Key("Back"));
    final submitButtonFinder = find.text("Submit");
    final addButtonFinder = find.byIcon(Icons.add);

    final schema = [
      {
        "label": "author",
        "readonly": false,
        "extra": {"related_model": "storage-management/author"},
        "name": "author_id",
        "widget": "foreignkey",
        "required": false,
        "translated": false,
        "validations": {}
      },
    ];

    final foreignKeySchema = [
      {
        "label": "title",
        "readonly": false,
        "extra": {},
        "name": "title",
        "widget": "text",
        "required": true,
        "translated": false,
        "validations": {
          "presence": true,
          "length": {"maximum": 128}
        }
      },
    ];

    final avaliableAuthors = [
      {"label": "hello world", "value": 1},
      {"label": "hello world2", "value": 2},
    ];

    testWidgets(
      "Test Update",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                values: {"author_id": avaliableAuthors[0]},
                schema: schema,
                onFetchingSchema: (path, isEdit, id) async {
                  return SchemaValues(
                    schema: foreignKeySchema,
                    values: {"title": "hello world"},
                  );
                },
                onFetchingforeignKeyChoices: (path) {
                  return;
                },
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: (path, values, id) async {
                  return Choice(label: values['title'], value: values['title']);
                },
                onDeleteforeignKeyField: null,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text("hello world"), findsOneWidget);
        await tester.tap(editButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text("hello world"), findsOneWidget);
        await tester.enterText(
          find.byKey(Key("textfield-title")),
          "hello world1",
        );

        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text("hello world1"), findsOneWidget);
      },
    );

    testWidgets(
      "Test Add",
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                values: {"author_id": avaliableAuthors[0]},
                schema: schema,
                onFetchingSchema: (path, isEdit, id) async {
                  return SchemaValues(
                    schema: foreignKeySchema,
                    values: {},
                  );
                },
                onFetchingforeignKeyChoices: (path) {
                  return;
                },
                onDeleteforeignKeyField: null,
                onAddforeignKeyField: (path, values) async {
                  return;
                },
                onUpdateforeignKeyField: (path, values, id) async {
                  return Choice(label: values['title'], value: values['title']);
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.tap(addButtonFinder);
        await tester.pumpAndSettle();
        await tester.enterText(
          find.byKey(Key("textfield-title")),
          "hello world1",
        );
        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();
      },
    );
  });
}
