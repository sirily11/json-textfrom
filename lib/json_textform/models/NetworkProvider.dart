import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/JSONForm.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/utils.dart';

class NetworkProvider with ChangeNotifier {
  Dio networkProvider;
  String url;
  GlobalKey<ScaffoldState> key = GlobalKey();
  Dio httpClient = Dio();

  NetworkProvider({
    this.networkProvider,
    this.url,
  });

  String _preProcessURL(String path) {
    String p = "$path/".replaceFirst("-", "_");
    String url = getURL(this.url, p);
    return url;
  }

  /// Get schema
  // Future<List<Map<String, dynamic>>> getEditSchema(String path) async {
  //   try {
  //     String u = _preProcessURL(path);
  //     Response response =
  //         await networkProvider.request(u, options: Options(method: "OPTIONS"));
  //     if ((response.data as Map).containsKey("fields"))
  //       return (response.data['fields'] as List)
  //           .map((d) => d as Map<String, dynamic>)
  //           .toList();
  //   } on DioError catch (e) {
  //     _showSnackBar(e.message);
  //   }
  //   return null;
  // }

  /// show error message
  void _showSnackBar(String message) {
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
