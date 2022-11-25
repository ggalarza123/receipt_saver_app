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


  TextEditingController categoryController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Images"),
      ),
      body: FutureBuilder<List<Uint8List>?>(
        future: _readImagesFromDatabase(),
        builder: (context, AsyncSnapshot<List<Uint8List>?> snapshot) {
          if (snapshot.data == null)
            return const Text("Nothing has been selected.");
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _showImageDetails(context, index);
                    // print(index);
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

  Future<void> _showImageDetails(BuildContext context, int index) async{
    // open box of image details
    await Hive.openBox('imageDetails');
    // grab the image details for this particular image selected
    Hive.box('imageDetails').get(index);
    // convert to a readable list by index
    List currentImageDetails = Hive.box('imageDetails').get(index);
    // setting the current details of the receipt
    dateController = new TextEditingController(text: currentImageDetails[0]);
    amountController = new TextEditingController(text: currentImageDetails[1]);
    categoryController = new TextEditingController(text: currentImageDetails[2]);
    notesController = new TextEditingController(text: currentImageDetails[3]);

    // shows the details of the receipt
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
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
                    onPressed: () {},
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

  void saveImageDetails(int id) async{
    String category = categoryController.text;
    String date = dateController.text;
    String amount = amountController.text;
    String notes = notesController.text;
    await Hive.openBox('imageDetails');
    Hive.box('imageDetails').putAt(id, [date, amount, category, notes]);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Image Details Saved"),
    ));
  }
}
