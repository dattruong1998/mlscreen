import 'package:flutter/material.dart';
import 'package:recognise/SQLHelper.dart';
class FileScreen extends StatefulWidget {
  @override
  _FileScreenState createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  var data = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  void getData() async{

    var resultData = await SQLHelper.getItems();
    setState(() {
      data = resultData;
    });
    debugPrint(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("File Screen")),
      body: ListView.builder(itemCount: data.length,itemBuilder: (context, index) {
        return data.length > 0 ?
            InkWell(child:  Card(child: ListTile(
              leading: Text(data[index]["id"].toString(), style: TextStyle(fontWeight: FontWeight.bold)),
              title: Text(data[index]["title"]),
              subtitle: Text(data[index]["createdAt"]),
            )),onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FileDetailsScreen(data[index]["description"])),
              )
            },)


            : Center(child: CircularProgressIndicator());
      }),
    );
  }
}

class FileDetailsScreen extends StatelessWidget {
  String information = "";

  FileDetailsScreen(String information) {
     this.information = information;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Details")),
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Text(information),
      ),
    ));
  }
}


