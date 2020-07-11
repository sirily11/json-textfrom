import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/components/pages/ManyToManySelectionPage.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form/json_textform/models/NetworkProvider.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:provider/provider.dart';

void main() {
  group("Test many to many field", () {
    final schema = [
      {
        "label": "collections",
        "readonly": false,
        "extra": {"related_model": "podcast/collection"},
        "name": "asset_collections",
        "widget": "manytomany-lists",
        "required": false,
        "translated": false,
        "validations": {}
      }
    ];

    final addSchema = [
      {
        "label": "title",
        "readonly": false,
        "extra": {},
        "name": "title",
        "widget": "text",
        "required": false,
        "translated": false,
        "validations": {}
      },
    ];

    final manyToManyFinder = find.text("Select collections");
    final doneButtonFinder = find.byIcon(Icons.done);
    final backButtonFinder = find.byKey(Key("Back"));
    final submitButtonFinder = find.text("Submit");
    final addButtonFinder = find.byIcon(Icons.add);
    final editButtonFinder = find.byKey(Key("Edit"));
    final titleFieldFinder = find.byKey(Key("textfield-title"));
    final deleteButtonFinder = find.byIcon(Icons.delete);
    testWidgets(
      "Render Selections",
      (WidgetTester tester) async {
        List<Choice> choices = [
          Choice(label: "A", value: 1),
        ];

        await tester.pumpWidget(MaterialApp(
          home: Material(
            child: ManyToManySelectionPage(
              title: "Select selections",
              icons: [],
              actions: [],
              isOutlined: false,
              onDeleteForignKeyField: null,
              onFetchingForignKeyChoices: (path) async {
                return [
                  Choice(label: "A", value: 1),
                  Choice(label: "B", value: 2),
                ];
              },
              name: "selections",
              onAddForignKeyField: (String path, Map<String, dynamic> values) {
                return;
              },
              onFetchingSchema: (String path, bool isEdit, id) async {
                return;
              },
              onFileUpload: (String path) async {
                return;
              },
              onUpdateForignKeyField:
                  (String path, Map<String, dynamic> values, id) {
                return;
              },
              schema: Schema(extra: Extra(relatedModel: "selections")),
              value: choices,
            ),
          ),
        ));
        await tester.pumpAndSettle();

        expect(find.byKey(Key("Checkbox-A-true")), findsOneWidget);
        expect(find.byKey(Key("Checkbox-B-false")), findsOneWidget);

        await tester.tap(find.text("A"));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-A-false")), findsOneWidget);
      },
    );

    testWidgets(
      "Submit Selections",
      (WidgetTester tester) async {
        // tap back button
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                onFetchingForignKeyChoices: (path) async {
                  return [
                    Choice(label: "A", value: 1),
                    Choice(label: "B", value: 2),
                  ];
                },
                onAddForignKeyField: (path, values) {
                  return;
                },
                schema: schema,
                values: {
                  "asset_collections": [
                    {"label": "A", "value": 1}
                  ]
                },
                onFetchingSchema: (String path, bool isEdit, id) {
                  return;
                },
                onUpdateForignKeyField:
                    (String path, Map<String, dynamic> values, id) {
                  return;
                },
                onDeleteForignKeyField: null,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(manyToManyFinder, findsOneWidget);
        await tester.tap(manyToManyFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-A-true")), findsOneWidget);
        expect(find.byKey(Key("Checkbox-B-false")), findsOneWidget);
        await tester.tap(find.text("B"));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-B-true")), findsOneWidget);
        await tester.tap(backButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(manyToManyFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-A-true")), findsOneWidget);
        expect(find.byKey(Key("Checkbox-B-false")), findsOneWidget);
      },
    );

    testWidgets(
      "Submit Selections 2",
      (WidgetTester tester) async {
        // Tap done button
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                onFetchingForignKeyChoices: (path) async {
                  return [
                    Choice(label: "A", value: 1),
                    Choice(label: "B", value: 2),
                  ];
                },
                onDeleteForignKeyField: null,
                onAddForignKeyField: (path, values) {
                  return;
                },
                schema: schema,
                values: {
                  "asset_collections": [
                    {"label": "A", "value": 1}
                  ]
                },
                onFetchingSchema: (String path, bool isEdit, id) {
                  return;
                },
                onUpdateForignKeyField:
                    (String path, Map<String, dynamic> values, id) {
                  return;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(manyToManyFinder, findsOneWidget);
        await tester.tap(manyToManyFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-A-true")), findsOneWidget);
        expect(find.byKey(Key("Checkbox-B-false")), findsOneWidget);
        await tester.tap(find.text("B"));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-B-true")), findsOneWidget);
        await tester.tap(doneButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(manyToManyFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-A-true")), findsOneWidget);
        expect(find.byKey(Key("Checkbox-B-true")), findsOneWidget);
      },
    );

    testWidgets(
      "Submit Selections 3",
      (WidgetTester tester) async {
        // Tap done button and submit
        final controller = JSONSchemaController();
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                onDeleteForignKeyField: null,
                onFetchingForignKeyChoices: (path) async {
                  return [
                    Choice(label: "A", value: 1),
                    Choice(label: "B", value: 2),
                  ];
                },
                onAddForignKeyField: (path, values) {
                  return;
                },
                schema: schema,
                values: {
                  "asset_collections": [
                    {"label": "A", "value": 1}
                  ]
                },
                onFetchingSchema: (String path, bool isEdit, id) {
                  return;
                },
                onUpdateForignKeyField:
                    (String path, Map<String, dynamic> values, id) {
                  return;
                },
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(manyToManyFinder, findsOneWidget);
        await tester.tap(manyToManyFinder);
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-A-true")), findsOneWidget);
        expect(find.byKey(Key("Checkbox-B-false")), findsOneWidget);
        await tester.tap(find.text("B"));
        await tester.pumpAndSettle();
        expect(find.byKey(Key("Checkbox-B-true")), findsOneWidget);
        await tester.tap(doneButtonFinder);
        await tester.pumpAndSettle();
        var result = await controller.onSubmit();
        expect(result['asset_collections'], [1, 2]);
      },
    );

    testWidgets(
      "Add new many to many field",
      (WidgetTester tester) async {
        // Add new field
        List<Choice> choices = [];

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                schema: schema,
                onFetchingSchema: (path, isEdit, id) async {
                  var index =
                      choices.indexWhere((element) => element.value == id);
                  if (index > -1) {
                    return SchemaValues(
                      schema: addSchema,
                      values: {"title": choices[index].value},
                    );
                  }
                  return SchemaValues(schema: addSchema, values: {});
                },
                onFetchingForignKeyChoices: (path) async {
                  return choices;
                },
                onAddForignKeyField: (path, values) async {
                  Choice choice =
                      Choice(label: values['title'], value: choices.length);
                  choices.add(choice);
                  return choice;
                },
                onUpdateForignKeyField: (path, values, id) async {
                  var index =
                      choices.indexWhere((element) => element.value == id);
                  if (index > -1) {
                    choices[index].label = values['title'];
                  }
                  return Choice(label: values['title'], value: id);
                },
                onDeleteForignKeyField: (path, id) async {
                  var removed = choices.removeAt(id);
                  return removed;
                },
              ),
            ),
          ),
        );

        // Add
        await tester.pumpAndSettle();
        await tester.tap(manyToManyFinder);
        await tester.pumpAndSettle();
        await tester.tap(addButtonFinder);
        await tester.pumpAndSettle();

        expect(deleteButtonFinder, findsNothing);
        await tester.enterText(titleFieldFinder, "Test1");
        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();

        // Edit
        expect(find.text("Test1"), findsOneWidget);
        await tester.tap(editButtonFinder);
        await tester.pumpAndSettle();
        expect(deleteButtonFinder, findsOneWidget);
        await tester.enterText(titleFieldFinder, "Test2");
        await tester.tap(submitButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text("Test2"), findsOneWidget);

        // Delete
        await tester.tap(editButtonFinder);
        await tester.pumpAndSettle();
        await tester.tap(deleteButtonFinder);
        await tester.pumpAndSettle();
        expect(find.text("Test2"), findsNothing);
      },
    );
  });
}
