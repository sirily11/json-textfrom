import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/JSONSchemaForm.dart';
import 'package:json_schema_form/json_textform/models/Controller.dart';
import 'package:json_schema_form/json_textform/models/components/FileFieldValue.dart';

void main() {
  group("Test File Field", () {
    final uploadFinder = find.byIcon(Icons.file_upload);
    final deleteOldFinder = find.byKey(Key("Delete Old"));
    final deleteNewFinder = find.byKey(Key("Delete New"));
    final restoreFinder = find.byKey(Key("Restore"));
    final temp = File("test.jpg");

    final schema = [
      {
        "label": "cover",
        "readonly": false,
        "extra": {},
        "name": "cover",
        "widget": "file",
        "required": false,
        "translated": false,
        "validations": {
          "length": {"maximum": 100}
        }
      },
    ];

    testWidgets(
      "Render without default",
      (WidgetTester tester) async {
        JSONSchemaController controller = JSONSchemaController();
        final temp = File("test.jpg");
        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                schema: schema,
                onFetchingSchema: null,
                onFetchingforeignKeyChoices: null,
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: null,
                onDeleteforeignKeyField: null,
                onFileUpload: (path) async {
                  return temp;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        await tester.tap(uploadFinder);
        await tester.pumpAndSettle();

        var result = await controller.onSubmit();
        expect(result['cover'], temp);
      },
    );

    testWidgets(
      "Render with default",
      (WidgetTester tester) async {
        JSONSchemaController controller = JSONSchemaController();

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                values: {
                  "cover": FileFieldValue(
                    path: "https://s3.test/test.jpg",
                  )
                },
                schema: schema,
                onFetchingSchema: null,
                onFetchingforeignKeyChoices: null,
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: null,
                onDeleteforeignKeyField: null,
                onFileUpload: (path) async {
                  return temp;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(deleteOldFinder, findsOneWidget);
        await tester.tap(uploadFinder);
        await tester.pumpAndSettle();

        var result = await controller.onSubmit();
        expect(result['cover'], temp);
      },
    );

    testWidgets(
      "Render with default 2",
      (WidgetTester tester) async {
        JSONSchemaController controller = JSONSchemaController();

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                values: {
                  "cover": FileFieldValue(
                    path: "https://s3.test/test.jpg",
                  )
                },
                schema: schema,
                onFetchingSchema: null,
                onFetchingforeignKeyChoices: null,
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: null,
                onDeleteforeignKeyField: null,
                onFileUpload: (path) async {
                  return temp;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        // Delete old one
        await tester.tap(deleteOldFinder);
        await tester.pumpAndSettle();
        // restore then
        await tester.tap(restoreFinder);
        await tester.pumpAndSettle();
        await tester.tap(uploadFinder);
        await tester.pumpAndSettle();

        var result = await controller.onSubmit();
        expect(result['cover'], temp);
      },
    );

    testWidgets(
      "Render with default 3",
      (WidgetTester tester) async {
        // render with default but don't change it
        JSONSchemaController controller = JSONSchemaController();

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                values: {
                  "cover": FileFieldValue(
                    path: "https://s3.test/test.jpg",
                  )
                },
                schema: schema,
                onFetchingSchema: null,
                onFetchingforeignKeyChoices: null,
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: null,
                onDeleteforeignKeyField: null,
                onFileUpload: (path) async {
                  return temp;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        // Delete old one
        await tester.tap(deleteOldFinder);
        await tester.pumpAndSettle();
        // restore then
        await tester.tap(restoreFinder);
        await tester.pumpAndSettle();

        var result = await controller.onSubmit();
        expect(result.containsKey('cover'), false);
      },
    );

    testWidgets(
      "Render with default 4",
      (WidgetTester tester) async {
        // render with default but clear it
        JSONSchemaController controller = JSONSchemaController();

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                values: {
                  "cover": FileFieldValue(
                    path: "https://s3.test/test.jpg",
                  )
                },
                schema: schema,
                onFetchingSchema: null,
                onFetchingforeignKeyChoices: null,
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: null,
                onDeleteforeignKeyField: null,
                onFileUpload: (path) async {
                  return temp;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        // Delete old one
        await tester.tap(deleteOldFinder);
        await tester.pumpAndSettle();
        var result = await controller.onSubmit();
        expect(result['cover'], null);
      },
    );

    testWidgets(
      "Render with default 5",
      (WidgetTester tester) async {
        // clear old and upload new
        JSONSchemaController controller = JSONSchemaController();

        await tester.pumpWidget(
          MaterialApp(
            home: Material(
              child: JSONSchemaForm(
                controller: controller,
                values: {
                  "cover": FileFieldValue(
                    path: "https://s3.test/test.jpg",
                  )
                },
                schema: schema,
                onFetchingSchema: null,
                onFetchingforeignKeyChoices: null,
                onAddforeignKeyField: null,
                onUpdateforeignKeyField: null,
                onDeleteforeignKeyField: null,
                onFileUpload: (path) async {
                  return temp;
                },
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        // Delete old one
        await tester.tap(deleteOldFinder);
        await tester.pumpAndSettle();
        await tester.tap(uploadFinder);
        await tester.pumpAndSettle();

        var result = await controller.onSubmit();
        expect(result['cover'], temp);
      },
    );
  });
}
