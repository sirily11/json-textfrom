import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/components/pages/ManyToManySelectionPage.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';

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

    final manyToManyFinder = find.text("Select collections");
    final doneButtonFinder = find.byIcon(Icons.done);
    final backButtonFinder = find.byKey(Key("Back"));
    final submitButtonFinder = find.text("Submit");
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
  });
}
