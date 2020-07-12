import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/json_textform/components/JSONSelectField.dart';
import 'package:json_schema_form/json_textform/components/pages/SelectionPage.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group("Selection Page Test", () {
    final Type radioListTileType = const RadioListTile<int>(
      value: 0,
      groupValue: 0,
      onChanged: null,
    ).runtimeType;

    List<RadioListTile<dynamic>> findTiles() => find
        .byType(RadioListTile)
        .evaluate()
        .map<Widget>((Element element) => element.widget)
        .cast<RadioListTile<dynamic>>()
        .toList();
    testWidgets("Render page without value", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SelectionPage(
            useDialog: false,
            title: "ABC",
            selections: [
              Choice(label: "a", value: "a"),
              Choice(label: "b", value: "b"),
              Choice(label: "c", value: "c")
            ],
          ),
        ),
      );
      expect(find.text("a"), findsOneWidget);
      expect(find.text("b"), findsOneWidget);
      expect(find.text("c"), findsOneWidget);
      var radios = findTiles();
      expect(radios[0].checked, equals(false));
      expect(radios[1].checked, equals(false));
      expect(radios[2].checked, equals(false));
    });

    testWidgets("Render page with value", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SelectionPage(
            useDialog: false,
            title: "ABC",
            selections: [
              Choice(label: "a", value: "a"),
              Choice(label: "b", value: "b"),
              Choice(label: "c", value: "c")
            ],
            value: "a",
          ),
        ),
      );
      expect(find.text("a"), findsOneWidget);
      expect(find.text("b"), findsOneWidget);
      expect(find.text("c"), findsOneWidget);
      var radios = findTiles();
      expect(radios[0].checked, equals(true));
      expect(radios[1].checked, equals(false));
      expect(radios[2].checked, equals(false));
    });

    testWidgets("Render page with value but not in selection", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SelectionPage(
            useDialog: false,
            title: "ABC",
            selections: [
              Choice(label: "a", value: "a"),
              Choice(label: "b", value: "b"),
              Choice(label: "c", value: "c")
            ],
            value: "d",
          ),
        ),
      );
      expect(find.text("a"), findsOneWidget);
      expect(find.text("b"), findsOneWidget);
      expect(find.text("c"), findsOneWidget);
      var radios = findTiles();
      expect(radios[0].checked, equals(false));
      expect(radios[1].checked, equals(false));
      expect(radios[2].checked, equals(false));
    });

    testWidgets("Render page with value and change selection", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SelectionPage(
            useDialog: false,
            title: "ABC",
            selections: [
              Choice(label: "a", value: "a"),
              Choice(label: "b", value: "b"),
              Choice(label: "c", value: "c")
            ],
            value: "a",
          ),
        ),
      );
      await tester.tap(find.text("b"));
      await tester.pump();
      var radios = findTiles();
      expect(radios[0].checked, equals(false));
      expect(radios[1].checked, equals(true));
      expect(radios[2].checked, equals(false));
      await tester.tap(find.byIcon(Icons.done));
      await tester.pump();
    });

    testWidgets("Render page with value and change selection with callback",
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SelectionPage(
            useDialog: false,
            title: "ABC",
            onSelected: (Choice v) {
              expect(v.label, "b");
            },
            selections: [
              Choice(label: "a", value: "a"),
              Choice(label: "b", value: "b"),
              Choice(label: "c", value: "c")
            ],
            value: "a",
          ),
        ),
      );
      await tester.tap(find.text("b"));
      await tester.pump();
      var radios = findTiles();
      expect(radios[0].checked, equals(false));
      expect(radios[1].checked, equals(true));
      expect(radios[2].checked, equals(false));
      await tester.tap(find.byIcon(Icons.done));
      await tester.pump();
    });

    testWidgets("Render search filter", (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SelectionPage(
            useDialog: false,
            title: "ABC",
            selections: [
              Choice(label: "a", value: "a"),
              Choice(label: "b", value: "b"),
              Choice(label: "c", value: "c")
            ],
            value: "a",
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), "a");
      await tester.pump();
      var radios = findTiles();
      expect(radios.length, 1);
    });

    testWidgets("Render selection button", (tester) async {
      var schema = {
        "label": "unit",
        "readonly": false,
        "extra": {
          "choices": [
            {"label": "US Dollar", "value": "USD"},
            {"label": "Hong Kong Dollar", "value": "HDK"},
            {"label": "RMB", "value": "CNY"}
          ],
          "default": "USD"
        },
        "name": "unit",
        "widget": "select",
        "required": false,
        "translated": false,
        "validations": {}
      };
      final mockObserver = MockNavigatorObserver();

      await tester.pumpWidget(
        MaterialApp(
          navigatorObservers: [mockObserver],
          home: Material(
            child: JSONSelectField(
              useDialog: false,
              useDropdownButton: false,
              schema: Schema.fromJSON(schema),
              isOutlined: false,
              filled: false,
            ),
          ),
        ),
      );

      expect(find.text("Select unit"), findsOneWidget);
      expect(find.text("USD"), findsOneWidget);
      await tester.tap(find.text("Select unit"));
      await tester.pump();
      await tester.pumpAndSettle();
      verify(mockObserver.didPush(any, any));
      expect(find.byType(SelectionPage), findsOneWidget);
    });
  });
}
