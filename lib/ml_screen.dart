

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:recognise/SQLHelper.dart';
import 'package:recognise/file_screen.dart';

class MLScanScreen extends StatefulWidget {
  const MLScanScreen({Key? key}) : super(key: key);

  @override
  _MLScanScreenState createState() => _MLScanScreenState();
}

class _MLScanScreenState extends State<MLScanScreen> {
  File? _imageFile;
  static const platform = const MethodChannel('ocr');
  var txtResult = "";

  @override
  void initState() {
    super.initState();
  }

  void pickImage() async {
    txtResult = "";
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      if (Platform.isIOS) {
        String result = await platform.invokeMethod(
            'doOcr', {"path": _imageFile!.path});
        setState(() {
          txtResult += result + "\n";
        });
      }
      if (Platform.isAndroid) {
         //here
      }
    }

  }
  void saveData() async {
    int id = await SQLHelper.createItem("folder", txtResult);
    if (id > 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => FileScreen()),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            Expanded(child: Container(
              child: Center(
                child: ElevatedButton(
                  child: Text("Pick Image"),
                  onPressed: () => pickImage(),
                ),
              ),
            ),flex: 1),
            _imageFile ==null ? SizedBox() : Expanded(child: Container(
              child:  Image.file(
                _imageFile!,
                fit: BoxFit.cover,
              ),
            ),flex: 3),
            SizedBox(height: 20),
            Expanded(child: Container(
              child:  SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Text(txtResult),
              ),
            ),flex: 3),
          ],
        ),
      ),
    );
  }
}



