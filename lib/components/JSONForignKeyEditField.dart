import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:json_schema_form/models/Action.dart';
import 'package:json_schema_form/models/Icon.dart';
import 'package:json_schema_form/models/Schema.dart';
import 'package:progress_indicators/progress_indicators.dart';

import '../JSONSchemaForm.dart';
import '../utils.dart';

class BaseEditField {
  GlobalKey<ScaffoldState> key = GlobalKey();
  Dio httpClient = Dio();

  String _preProcessURL(String base, String path) {
    String p = "$path/".replaceFirst("-", "_");
    String url = getURL(base, p);
    return url;
  }

  /// Update current forign key's value
  /// Only call this method if the mode is editing
  Future updateField(
      String base, String path, Map<String, dynamic> json, dynamic id) async {
    try {
      String url = "${_preProcessURL(base, path)}$id/";
      Response response = await httpClient.patch(url, data: json);
      return;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
  }

  /// Add new forign key
  /// Only call this method if the mode is not edit
  Future addField(String base, String path, Map<String, dynamic> json) async {
    try {
      String url = _preProcessURL(base, path);
      Response response = await httpClient.post(url, data: json);
      return;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
  }

  /// Get schema
  Future<List<Map<String, dynamic>>> getEditSchema(
      String base, String path) async {
    try {
      String url = _preProcessURL(base, path);
      Response response =
          await httpClient.request(url, options: Options(method: "OPTIONS"));
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
  Future<Map<String, dynamic>> getValues(
      String base, String path, dynamic id) async {
    try {
      String url = "${_preProcessURL(base, path)}$id/";
      Response response = await httpClient.get(url);
      return response.data;
    } on DioError catch (e) {
      _showSnackBar(e.message);
    }
    return null;
  }
}

/// This is the field for forign key.
/// For example if model b is forign key of model a
/// This will create/ update model b
/// based on the path
class JSONForignKeyEditField extends StatefulWidget {
  /// Model path
  final String path;

  /// On submit button has been clicked
  final Function onSubmit;

  /// Page's title
  final String title;

  /// Page's name
  /// This one is different from the title
  /// and will be used to merge actions and icons.
  final String name;

  /// Model's id. This will be provided if
  /// and only if the mode is editing mode
  final dynamic id;
  final String baseURL;

  /// Whether the mode is editing mode
  final bool isEdit;
  final bool isOutlined;
  final Dio httpClient;

  /// List of actions. Each field will only have one action.
  /// If not, the last one will replace the first one.
  final List<FieldAction> actions;

  /// List of icons. Each field will only have one icon.
  /// If not, the last one will replace the first one.
  final List<FieldIcon> icons;

  JSONForignKeyEditField(
      {@required this.path,
      this.onSubmit,
      this.title,
      this.id,
      this.isOutlined = false,
      this.isEdit = false,
      this.httpClient,
      @required this.name,
      @required this.baseURL,
      this.actions,
      this.icons});

  @override
  _JSONForignKeyEditFieldState createState() => _JSONForignKeyEditFieldState();
}

class _JSONForignKeyEditFieldState extends State<JSONForignKeyEditField>
    with BaseEditField {
  List<Map<String, dynamic>> schemas = [];
  Map<String, dynamic> values;

  @override
  void initState() {
    super.initState();
    if (widget.httpClient != null) {
      httpClient = widget.httpClient;
    }
    getEditSchema(widget.baseURL, widget.path).then((value) {
      if (value != null) {
        setState(() {
          schemas = value;
        });
      }
    });
    if (widget.isEdit) {
      getValues(widget.baseURL, widget.path, widget.id).then((v) {
        setState(() {
          values = v;
        });
      });
    } else {
      // If this is not edit mode, set values to empty
      values = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
          title: schemas.length > 0 && values != null
              ? Text(widget.title)
              : JumpingDotsProgressIndicator(
                  color: Colors.white,
                  fontSize: 26,
                )),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: schemas.length > 0 && values != null
            ? JSONSchemaForm(
                schemaName: widget.name,
                rounded: widget.isOutlined,
                schema: schemas,
                values: values,
                actions: widget.actions,
                icons: widget.icons,
                onSubmit: (Map<String, dynamic> json) async {
                  if (widget.isEdit) {
                    await updateField(
                        widget.baseURL, widget.path, json, widget.id);
                  } else {
                    await addField(widget.baseURL, widget.path, json);
                  }
                  Navigator.pop(context);
                },
              )
            : Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
