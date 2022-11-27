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
      return const Padding(
        padding: EdgeInsets.only(top: 60, bottom: 160, left: 0, right: 0),
        child: Text("No Image Selected"),
      );
    } else {
      // Photo returned here
      return Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10, left: 0, right: 0),
        child: Image.file(image!, height: 400, width: 400),
      );
    }
  }

  // Initial display widget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Receipt Saver"),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _decideImageView(),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: ElevatedButton(
                  onPressed: () {
                    _showChoiceDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 0.0,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'Select Image',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ElevatedButton(
                onPressed: () {
                  saveImage();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 0.0,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Text(
                    'Save Image',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Converting the selected image into a Uint8List, bytearray list, the image will be in numbers.
  // This will then be stored in the database
  void saveImage() async {
    Uint8List imageBytes = await image!.readAsBytes();
    adapter.storeImage(imageBytes);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Image Saved"),
    ));
  }
}
