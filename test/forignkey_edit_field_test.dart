import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/components/JSONForignKeyEditField.dart';
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements Dio {}

void main() {
  group("Test Forignkey", () {
    Dio httpClient = MockHttpClient();

    // setUp(() {
    //   httpClient = MockHttpClient();

    // });

    testWidgets("Get schema with null data", (tester) async {
      when(httpClient.request(any, options: anyNamed("options")))
          .thenAnswer((_) => Future.value(Response(data: {"err": "err"})));
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: JSONForignKeyEditField(
              name: "abc",
              baseURL: "http://0.0.0.0",
              path: "/aaa",
              httpClient: httpClient,
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
