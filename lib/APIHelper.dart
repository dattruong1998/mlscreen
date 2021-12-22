import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:recognise/product_model.dart';

var http_url = "https://61c285189cfb8f0017a3e587.mockapi.io/api/v1/qr/";

Future<ProductModel> getInformation (String code) async{
    var code_uri = http_url + code;
    var response = await http.get(Uri.parse(code_uri));
    var productModel = ProductModel.fromJson(jsonDecode(response.body));
    return productModel;
}