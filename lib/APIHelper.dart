import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recognise/product_model.dart';
import 'constants.dart';

Future<ProductModel> getInformation (String code) async{
    try {
        var code_uri = Constants.endpoint + code;
        var response = await http.get(Uri.parse(code_uri));
        var productModel = ProductModel.fromJson(jsonDecode(response.body));
        return productModel;
    } catch(error){
        return ProductModel();
    }
}