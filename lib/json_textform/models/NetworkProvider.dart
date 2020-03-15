import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/json_textform/models/Schema.dart';
import 'package:json_schema_form/json_textform/utils.dart';

class NetworkProvider with ChangeNotifier {
  Dio networkProvider;
  String url;
  GlobalKey<ScaffoldState> key = GlobalKey();
  Dio httpClient = Dio();

  NetworkProvider({this.networkProvider, this.url});

  Future<List<Choice>> getSelections(String path) async {
    String p = "$path/".replaceFirst("-", "_");
    String url = getURL(this.url, p);
    Response response = await Dio().get<List<dynamic>>(url);
    return (response.data as List)
        .map((d) => Choice(label: d['name'].toString(), value: d['id']))
        .toList();
  }

  String _preProcessURL(String path) {
    String p = "$path/".replaceFirst("-", "_");
    String url = getURL(this.url, p);
    return url;
  }

  /// Update current forign key's value
  /// Only call this method if the mode is editing
  Future updateField(String path, Map<String, dynamic> json, dynamic id) async {
    try {
      String u = "${_preProcessURL(path)}$id/";
      Response response = await networkProvider.patch(u, data: json);
      return;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
  }

  /// Add new forign key
  /// Only call this method if the mode is not edit
  Future addField(String path, Map<String, dynamic> json) async {
    try {
      String u = _preProcessURL(path);
      Response response = await networkProvider.post(u, data: json);
      return;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
  }

  /// Get schema
  Future<List<Map<String, dynamic>>> getEditSchema(String path) async {
    try {
      String u = _preProcessURL(path);
      Response response =
          await networkProvider.request(u, options: Options(method: "OPTIONS"));
      if ((response.data as Map).containsKey("fields"))
        return (response.data['fields'] as List)
            .map((d) => d as Map<String, dynamic>)
            .toList();
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
    return null;
  }

  /// show error message
  void _showSnackBar(String message) {
    key.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  /// get values
  Future<Map<String, dynamic>> getValues(String path, dynamic id) async {
    try {
      String u = "${_preProcessURL(path)}$id/";
      Response response = await httpClient.get(u);
      return response.data;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
    return null;
  }
}
