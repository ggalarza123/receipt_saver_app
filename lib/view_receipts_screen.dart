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
          if (snapshot.hasError) {
            return Text("Error appeared ${snapshot.error}");
          }

          if (snapshot.hasData) {
            if (snapshot.data == null) return const Text("Nothing to show");

            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) => Image.memory(
                snapshot.data![index],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }


  Future<List<Uint8List>?> _readImagesFromDatabase() async {
    return adapter.getImages();
  }

}
