import 'dart:typed_data';
import 'package:hive/hive.dart';
import 'package:receipt_saver_app/database_adapter.dart';

class HiveService extends DatabaseAdapter {
  // This function will be used to retreive the List of images but not its data
  @override
  Future<List<Uint8List>> getImages() async {
    var box = await Hive.openBox('imageBox');
    List<dynamic> result = box.get('images');
    return result.cast<Uint8List>();
  }

  // The U8list will be stored using this method, as well as create empty lists of data for each image
  @override
  Future<void> storeImage(Uint8List imageBytes) async {
    // This list will hold all images that exist at the end to be saved
    List<Uint8List> images = [];
    var box = await Hive.openBox('imageBox');
    // This list grabs all the images that exist and stores them in a list
    List<dynamic>? allImages = box.get("images");
    if (allImages != null) {
      images.addAll(allImages.cast<Uint8List>());
    }
    images.add(imageBytes);
    box.put("images", images);

    // Creates a second box within Hive and stores an empty string list that will be filled later
    var box2 = await Hive.openBox('imageDetails');
    box2.add(["", "", "", ""]);
  }
}
