import 'dart:io';
import 'dart:core';

import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddReceiptScreen extends StatefulWidget {
  @override
  _AddReceiptScreen createState() => _AddReceiptScreen();
}

class _AddReceiptScreen extends State<AddReceiptScreen> {

  XFile? imageFile;

  @override
  void initState() {
    super.initState();
  }

  _openGallery(BuildContext context) async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    this.setState(() {

    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
    this.setState(() {

    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Make a choice."),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  Widget _decideImageView() {
    if (imageFile == null) {
      return Text("No Image Selected");
    } else {
      return Image.file(File(imageFile!.path), height: 400, width: 400);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Saver"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _decideImageView(),
            TextButton(
              onPressed: () {
                _showChoiceDialog(context);
              },
              child: Container(
                color: Colors.lightBlue,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  'Select Image',
                  style: TextStyle(color: Colors.white, fontSize: 28.0),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // saveImage(imageFile?.path);
                saveFile();
                // readFile();
              },
              child: Container(
                color: Colors.lightBlue,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: const Text(
                  'Save Image',
                  style: TextStyle(color: Colors.white, fontSize: 28.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }




















  void saveImage() async {
    if (imageFile == null) {
      return;
    }


    // SharedPreferences saveImage = await SharedPreferences.getInstance();
    //
    //  File file = File(imageFile!.path);
    // print(Image.file(File(imageFile!.path)));
  }


  Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/demoTextFile.txt'; // 3

    return filePath;
  }

  void saveFile() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/demoTextFile.txt';
    File newImage = await File(imageFile!.path).copy('$filePath/image1.png');

    // File file = File(await getFilePath());
    // File file = File(imageFile!.path); // 1

    // file.writeAsString("This is my demo text that will be saved to : demoTextFile.txt"); // 2
  }

  void readFile() async {
    File file = File(await getFilePath()); // 1
    String fileContent = await file.readAsString(); // 2

    print('File Content: $fileContent');
  }

}
