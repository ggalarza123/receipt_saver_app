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
          if (snapshot.hasError) {
            return const Text("Nothing to show");
          }
          if (snapshot.hasData) {
            if (snapshot.data == null) return const Text("Nothing to show");
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    // Passing through the index so we know which image details from our list to display
                    _showImageDetails(context, index);
                  },
                  child: Padding(
                    // Adding padding to the receipt images to more easily see where a new one starts
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
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 14, bottom: 8, left: 8, right: 8),
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          saveImageDetails(index);
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
                            'SAVE',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      child: ElevatedButton(
                        onPressed: () {
                          deleteImage(index);
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 0.0,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'DELETE',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
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
    adapter.storeImageDetails(id, date, amount, category, notes);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Image Details Saved"),
    ));
  }

  // Delete image calling the adapter method
  void deleteImage(int index) async {
    adapter.deleteImage(index);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Image Deleted"),
    ));
    // Resets the view receipts screen to reflect the deleted image
    setState(() {
      _ViewReceiptsScreen();
    });
  }
}
