import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'database_adapter.dart';
import 'hive_service.dart';

class ViewReceiptsScreen extends StatefulWidget {
  @override
  _ViewReceiptsScreen createState() => _ViewReceiptsScreen();
}

class _ViewReceiptsScreen extends State<ViewReceiptsScreen> {
  DatabaseAdapter adapter = HiveService();

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
                    _showImageDetails(context);
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

  Future<void> _showImageDetails(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Receipt Details", textAlign: TextAlign.center,),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Date: ',
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Amount: ',
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Category: ',
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Notes: ',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                    },
                    child: Container(
                      color: Colors.lightBlue,
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: const Text(
                        'SAVE',
                        style: TextStyle(color: Colors.white, fontSize: 28.0),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                    },
                    child: Container(
                      color: Colors.red,
                      padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
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


}
