import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddReceiptScreen extends StatefulWidget {
  @override
  _AddReceiptScreen createState() => _AddReceiptScreen();
}

class _AddReceiptScreen extends State<AddReceiptScreen> {

  XFile? imageFile;


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
              onPressed: () {},
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
}
