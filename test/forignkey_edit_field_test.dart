import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_schema_form/components/JSONForignKeyEditField.dart';
import 'package:json_schema_form/models/NetworkProvider.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

class MockHttpClient extends Mock implements Dio {}

class MockProvider extends Mock implements NetworkProvider {}

void main() {
  group("Test Forignkey", () {
    Dio httpClient = MockHttpClient();
    NetworkProvider provider = MockProvider();

    testWidgets("Get schema with null data", (tester) async {
      when(provider.getEditSchema(any))
          .thenAnswer((_) async => Future.value(null));
      when(provider.getValues(any, any)).thenAnswer((_) => Future.value({}));
      provider.url = "a";

      // when(httpClient.request(any, options: Options(method: "OPTIONS")))
      //     .thenAnswer(
      //   (_) async => Response<Map<String, dynamic>>(data: {}),
      // );

      // when(httpClient.get(any)).thenAnswer(
      //   (_) async => Response<Map<String, dynamic>>(data: {}),
      // );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => provider,
            )
          ],
          child: MaterialApp(
            home: Material(
              child: JSONForignKeyEditField(
                path: "abc",
                name: "name_id",
              ),
            ),
          ),
        ),
      );
      // await tester.pumpAndSettle(Duration(seconds: 4));
      await tester.pump();
      await tester.pump();
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    }, skip: true);
  }, skip: true);
}
