import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'database_adapter.dart';
import 'hive_service.dart';

class ViewReceiptsScreen extends StatefulWidget {
  @override
  _ViewReceiptsScreen createState() => _ViewReceiptsScreen();
}

class _ViewReceiptsScreen extends State<ViewReceiptsScreen> {
  DatabaseAdapter adapter = HiveService();

  // Setting the text controller to later save and display data
  TextEditingController categoryController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // Main role of this widget is to build a FutureBuilder that will display each image that has been saved
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Images"),
      ),
      body: FutureBuilder<List<Uint8List>?>(
        future: _readImagesFromDatabase(),
        builder: (context, AsyncSnapshot<List<Uint8List>?> snapshot) {
          if (snapshot.data == null) {
            return const Text("Nothing has been selected.");
          }
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Passing through the index so we know which image details from our list to display
                    _showImageDetails(context, index);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.memory(
                      snapshot.data![index],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    return adapter.getImages();
  }

  Future<void> _showImageDetails(BuildContext context, int index) async {
    // Open box of image details
    await Hive.openBox('imageDetails');
    // Grab the image details for this particular image selected
    await Hive.box('imageDetails').get(index);
    // Convert to a readable list by index
    List currentImageDetails;

    if (Hive.box('imageDetails').getAt(index) != null) {
      List currentImageDetails = Hive.box('imageDetails').getAt(index);

      // Setting the current details of the receipt
      dateController = TextEditingController(text: currentImageDetails[0]);
      amountController = TextEditingController(text: currentImageDetails[1]);
      categoryController = TextEditingController(text: currentImageDetails[2]);
      notesController = TextEditingController(text: currentImageDetails[3]);
    }
    // Shows the details of the receipt selected
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Receipt Details",
              textAlign: TextAlign.center,
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Date: ',
                    ),
                  ),
                  TextFormField(
                    controller: amountController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Amount: ',
                    ),
                  ),
                  TextFormField(
                    controller: categoryController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Category: ',
                    ),
                  ),
                  TextFormField(
                    controller: notesController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Notes: ',
                    ),
                  ),
                  TextButton(
                    onPressed: () async {
                      saveImageDetails(index);
                    },
                    child: Container(
                      color: Colors.lightBlue,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: const Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white, fontSize: 28.0),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      deleteImage(index);
                    },
                    child: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: const Text(
                        'DELETE',
                        style: TextStyle(color: Colors.white, fontSize: 28.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void saveImageDetails(int id) async {
    String category = categoryController.text;
    String date = dateController.text;
    String amount = amountController.text;
    String notes = notesController.text;
    Hive.box('imageDetails').putAt(id, [date, amount, category, notes]);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Image Details Saved"),
    ));
  }

  // Deletes image but then data gets all mixed up
  void deleteImage(int index) async {
    List<Uint8List> images = [];
    var box = await Hive.openBox('imageBox');
    // This list grabs all the images that exist and stores them in a list
    List<dynamic>? allImages = box.get("images");
    // Remove the current image being deleted
    allImages!.removeAt(index);
    // Adds all current images to the new list
    if (allImages != null) {
      images.addAll(allImages.cast<Uint8List>());
    }
    // Save the new list of images
    box.put("images", images);

    // Open the box containing image details
    var box2 = Hive.box('imageDetails');
    // Delete the details for the image being deleted
    await box2.deleteAt(index);
    // Starting at the current image being deleted, replace it with the imagedetails above
    // Since the deleteAt function above does not auto shrink the list
    for (int i = index; i < box2.length; i++) {
      // If we are not at the end of the list, place the imagedetails one index down
      // Avoids index out of bounds
      if (i + 1 != box2.length) {
        List temp = box2.getAt(i);
        temp = box2.getAt(i + 1);
      }
    }
    // Resets the view receipts screen to reflect the deleted image
    setState(() {
      _ViewReceiptsScreen();
    });
  }
}
