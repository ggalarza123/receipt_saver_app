import 'dart:io';
import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:receipt_saver_app/database_adapter.dart';
import 'package:receipt_saver_app/hive_service.dart';

class AddReceiptScreen extends StatefulWidget {
  @override
  _AddReceiptScreen createState() => _AddReceiptScreen();
}

class _AddReceiptScreen extends State<AddReceiptScreen> {
  DatabaseAdapter adapter = HiveService();
  File? image;

  @override
  void initState() {
    super.initState();
  }

  _openGallery(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    final imageTemporary = File(image!.path);
    this.setState(() {
      this.image = imageTemporary;
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    final imageTemporary = File(image!.path);
    this.setState(() {
      this.image = imageTemporary;
    });
    Navigator.of(context).pop();
  }

  // Opens a dialog for user to select Gallery or Camera in order to upload a receipt.
  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Make a choice."),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: const Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                  const Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: const Text("Camera"),
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

  // Displays a text or image
  Widget _decideImageView() {
    if (image == null) {
      return const Text("No Image Selected");
    } else {
      // Photo returned here
      return Image.file(image!, height: 400, width: 400);
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
                saveImage();
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

  // converting the selected image into a Uint8List, bytearray list, the image will be in numbers.
  // this iwll then be stored in the database
  void saveImage() async {
    Uint8List imageBytes = await image!.readAsBytes();
    adapter.storeImage(imageBytes);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Image Saved"),
    ));
  }
}
