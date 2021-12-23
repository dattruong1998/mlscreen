

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recognise/SQLHelper.dart';
import 'package:recognise/file_screen.dart';
import 'constants.dart';
import 'input_image.dart';

class MLScanScreen extends StatefulWidget {
  const MLScanScreen({Key? key}) : super(key: key);

  @override
  _MLScanScreenState createState() => _MLScanScreenState();
}

class _MLScanScreenState extends State<MLScanScreen> {
  File? _imageFile;
  static const platform = const MethodChannel('ocr');
  var txtResult = [];

  @override
  void initState() {
    super.initState();
  }

  void pickImage() async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    var result = [];
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      if (Platform.isIOS) {
         result = await platform.invokeMethod(
             Constants.ocr_method_name, {"path": _imageFile!.path});
      }
      if (Platform.isAndroid) {
        result = await platform.invokeMethod(Constants.ocr_method_name,
            <String, dynamic>{'imageData': InputImage.fromFilePath(_imageFile!.path).getImageData()});
      }
      setState(() {
        txtResult = result;
      });
    }
  }
  void saveData() async {
    if (txtResult.length > 0) {
      int id = await SQLHelper.createItem(txtResult[0], txtResult[1]);
      if (id > 0) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FileScreen()),
        );
      }
    } else {
      print("You do not select file");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan image"),
        actions: [
          IconButton(onPressed: () => saveData(), icon: Icon(Icons.save))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(child: Container(
              child: Center(
                child: ElevatedButton(
                  child: Text("Scan Image"),
                  onPressed: () => pickImage(),
                ),
              ),
            ),flex: 1),
            _imageFile ==null ? SizedBox() : Expanded(child: Container(
              child:  Image.file(
                _imageFile!,
                fit: BoxFit.contain,
              ),
            ),flex: 2),
            SizedBox(height: 20),
            Expanded(
              child:  Padding(
                padding: EdgeInsets.all(10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: txtResult.length > 0 ? Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text("Product Title", style: TextStyle(fontWeight: FontWeight.bold)), flex: 3),
                          Expanded(child: Text(txtResult[0]), flex: 3),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(child: Text("Product description",style: TextStyle(fontWeight: FontWeight.bold)), flex: 3),
                          Expanded(child: Text(txtResult[1]), flex: 3),
                        ],
                      )
                    ],
                  ): SizedBox(),
                ),
              ),flex: 3),
          ],
        ),
      ),
    );
  }
}



