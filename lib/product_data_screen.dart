import 'package:flutter/material.dart';
import 'package:recognise/SQLHelper.dart';
import 'package:recognise/product_model.dart';

import 'file_screen.dart';

class ProductDataScreen extends StatefulWidget {
  ProductModel productModel = ProductModel();
  ProductDataScreen(ProductModel productModel){
    this.productModel = productModel;
  }
  @override
  _ProductDataScreenState createState() => _ProductDataScreenState();
}

class _ProductDataScreenState extends State<ProductDataScreen> {

  void saveData () async {
    int data = await SQLHelper.createItem(widget.productModel.title, widget.productModel.id);
    print(data);
    if (data > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Details"),actions: [
          IconButton(onPressed: () => saveData(), icon: Icon(Icons.save))
        ],),
        body: Container(
          padding: EdgeInsets.only(top: 300.0, left: 20),
          width: double.infinity,
          height: double.infinity,
          child: ListView(
            children: [
              Text("Info:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(child: Text("Product title:", style: TextStyle(fontWeight: FontWeight.bold),), flex: 3),
                  Expanded(child: Text(widget.productModel.title,style: TextStyle(fontWeight: FontWeight.bold)), flex: 3)
                ],
              ),
              Row(
                children: [
                  Expanded(child: Text("Product description:",style: TextStyle(fontWeight: FontWeight.bold)), flex: 3),
                  Expanded(child: Text(widget.productModel.description,style: TextStyle(fontWeight: FontWeight.bold)), flex: 3)
                ],
              )
            ],
          ),
        )
    );
  }
}

