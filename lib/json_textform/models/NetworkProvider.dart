import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class NetworkProvider with ChangeNotifier {
  Dio networkProvider;
  String url;
  GlobalKey<ScaffoldState> key = GlobalKey();
  Dio httpClient = Dio();

  NetworkProvider({
    this.networkProvider,
    this.url,
  });

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

}
