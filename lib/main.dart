import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:recognise/APIHelper.dart';
import 'package:recognise/file_screen.dart';
import 'package:recognise/ml_screen.dart';
import 'package:recognise/product_data_screen.dart';
import 'package:recognise/product_model.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ScanApp()
    );
  }
}

class ScanApp extends StatefulWidget {
  const ScanApp({Key? key}) : super(key: key);

  @override
  _ScanAppState createState() => _ScanAppState();
}

class _ScanAppState extends State<ScanApp> {
  var codeResult = "";
  var isLoading = false;

  void scanCode() async {
    var code = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    setState(() {
      codeResult = code;
    });
    fetchInfor();
  }

  void fetchInfor() async {
    setState(() {
      isLoading = true;
    });
    ProductModel productModel = await getInformation(codeResult);
    if (productModel.id.isNotEmpty) {
      setState(() {
        isLoading = false;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=> ProductDataScreen(productModel)));
    } else {
      print("Can not find this id");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isLoading ? CircularProgressIndicator(strokeWidth: 2,color: Colors.blueAccent):
        Row(
          children: [
            Expanded(child: ElevatedButton(child: Text("Scan By QR"),onPressed: () =>{
              scanCode()
            }), flex: 3),
            SizedBox(width: 20),
            Expanded(child: ElevatedButton(child: Text("Recognise Text"),onPressed: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) => MLScanScreen()))

            }), flex: 3)
          ],
        ),
    ));
  }
}

